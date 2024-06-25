# GNU General Public License
# 
# Wrilya: A Community Oriented Game
# 
# Copyright (C) 2024 Decentralized Consulting
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

# -----------------------------------------------------------------------------
# Imports
# -----------------------------------------------------------------------------
import pulumi #type: ignore
import pulumi_gcp as gcp #type: ignore
import pulumi_random as random #type: ignore
from pulumi_kubernetes.apps.v1 import Deployment, DeploymentSpecArgs #type: ignore
from pulumi_kubernetes.apps.v1 import StatefulSet, StatefulSetSpecArgs #type: ignore
from pulumi_kubernetes.core.v1 import ConfigMap, ConfigMapEnvSourceArgs #type: ignore
from pulumi_kubernetes.core.v1 import Secret, SecretEnvSourceArgs #type: ignore
from pulumi_kubernetes.core.v1 import ContainerArgs, ContainerPortArgs #type: ignore
from pulumi_kubernetes.core.v1 import EnvFromSourceArgs #type: ignore
from pulumi_kubernetes.core.v1 import ExecActionArgs #type: ignore
from pulumi_kubernetes.core.v1 import HostPathVolumeSourceArgs #type: ignore
from pulumi_kubernetes.core.v1 import Namespace #type: ignore
from pulumi_kubernetes.core.v1 import PersistentVolume, PersistentVolumeSpecArgs #type: ignore
from pulumi_kubernetes.core.v1 import PersistentVolumeClaim, PersistentVolumeClaimSpecArgs #type: ignore
from pulumi_kubernetes.core.v1 import PersistentVolumeClaimVolumeSourceArgs #type: ignore
from pulumi_kubernetes.core.v1 import PodTemplateSpecArgs, PodSpecArgs #type: ignore
from pulumi_kubernetes.core.v1 import ProbeArgs #type: ignore
from pulumi_kubernetes.core.v1 import ResourceRequirementsArgs #type: ignore
from pulumi_kubernetes.core.v1 import SecretVolumeSourceArgs, SecurityContextArgs #type: ignore
from pulumi_kubernetes.core.v1 import Service, ServiceSpecArgs, ServicePortArgs #type: ignore
from pulumi_kubernetes.core.v1.outputs import TCPSocketAction #type: ignore
from pulumi_kubernetes.core.v1 import VolumeArgs, VolumeMountArgs #type: ignore
from pulumi_kubernetes.meta.v1 import LabelSelectorArgs #type: ignore
from pulumi_kubernetes.meta.v1 import ObjectMetaArgs #type: ignore

# -----------------------------------------------------------------------------
# Global Configuration Setup
# -----------------------------------------------------------------------------
stack = pulumi.get_stack()
org = pulumi.get_organization()
provider_cfg = pulumi.Config("gcp")
gcp_project = provider_cfg.require("project")
gcp_region = provider_cfg.require("region")
config = pulumi.Config()
namespace = config.get("namespace")

# -----------------------------------------------------------------------------
# Namespace Setup
#
# Create the namespace used by this cluster
# -----------------------------------------------------------------------------
wrilya_namespace = Namespace(
    "wrilya-namespace",
    metadata=ObjectMetaArgs(
        name=f"{namespace}",
    )
)

pulumi.export(f"namespace::id", wrilya_namespace.id)
pulumi.export(f"namespace::name", namespace)

# -----------------------------------------------------------------------------
# Create the persistent volume to store the postgres data
# -----------------------------------------------------------------------------

persistent_volume_claim = PersistentVolumeClaim(
    "wrilya-postgres-pvc",
    metadata=ObjectMetaArgs(
        name=f"postgres-pvc", # Name of the PersistentVolume
        namespace=namespace,
        labels={ "app": "postgres" }
    ),
    spec=PersistentVolumeClaimSpecArgs(
        #storage_class_name="standard",
        #access_modes=["ReadWriteMany"], # Define the access modes
        access_modes=["ReadWriteOnce"], # Define the access modes
        resources=ResourceRequirementsArgs(
            requests={"storage": "1Gi"},   # Define the storage capacity
        )
    )
)

pulumi.export('postgres::persistent_volume_claim', persistent_volume_claim.metadata["name"])

# -----------------------------------------------------------------------------
# Postgres Secret Generation
#
# If the secret doesn't already exist then we will create a new one.
# otherwise reuse the current secret.  This might not be the best way to
# manage/rotate secrets which will need to be revisited for production systems
# but for now it should be good enough while in fast development mode
# -----------------------------------------------------------------------------
postgres_password = random.RandomPassword(
    "wrilya-postgres-password-gen",
    length=16,
    special=False)

secret = gcp.secretmanager.Secret(
    "wrilya-postgres-password-sm",
    secret_id=f"wrilya-postgres-password-{stack}",
    project=gcp_project,
    replication=gcp.secretmanager.SecretReplicationArgs(
        user_managed=gcp.secretmanager.SecretReplicationUserManagedArgs(
            replicas=[
                gcp.secretmanager.SecretReplicationUserManagedReplicaArgs(
                    location=gcp_region,
                ),
            ],
        ),
    )
)
secret_version = gcp.secretmanager.SecretVersion(
    "wrilya-secret-version-sm",
    secret=secret.id,
    secret_data=postgres_password.result)

# -----------------------------------------------------------------------------
# Postgres Secret Map
# -----------------------------------------------------------------------------
postgres_secret_map = Secret(
    "wrilya-postgres-secret",
    metadata=ObjectMetaArgs(
        name=f"postgres-secret",
        namespace=namespace,
        labels={ "app": "postgres" }
    ),
    string_data={
        "POSTGRES_PASSWORD": postgres_password.result,
        "POSTGRES_URL": postgres_password.result.apply(lambda p: f"postgres://postgres:{p}@postgres.{namespace}.svc.cluster.local:5432/postgres"),
        "DATABASE_URL": postgres_password.result.apply(lambda p: f"postgres://postgres:{p}@postgres.{namespace}.svc.cluster.local:5432/postgres")
    }
)

pulumi.export('postgres::secret::id', postgres_secret_map.id)
pulumi.export('postgres::secret::name', postgres_secret_map.metadata["name"])

# -----------------------------------------------------------------------------
# Postgres Config
# -----------------------------------------------------------------------------
postgres_config_map = ConfigMap(
    "wrilya-postgres-config",
    metadata=ObjectMetaArgs(
        name=f"postgres-config",
        namespace=namespace,
        labels={ "app": "postgres" }
    ),
    data={
        "POSTGRES_DEPLOYMENT": f"{namespace}",
        "POSTGRES_HOST": f"postgres.{namespace}.svc.cluster.local",
        "POSTGRES_PORT": "5432",
        "POSTGRES_USER": "postgres",
    }
)

pulumi.export('postgres::config::id', postgres_config_map.id)
pulumi.export('postgres::config::name', postgres_config_map.metadata["name"])

# -----------------------------------------------------------------------------
# Postgres Deployment
# -----------------------------------------------------------------------------
postgres_deployment = StatefulSet(
    "wrilya-postgres",
    kind="Deployment",
    metadata=ObjectMetaArgs(
        name="postgres",
        namespace=namespace,
        labels={ "app": "postgres" }
    ),
    spec=StatefulSetSpecArgs(
        service_name="postgres",
        selector=LabelSelectorArgs(
            match_labels={ "app": "postgres" },
        ),
        replicas=1,
        template=PodTemplateSpecArgs(
            metadata=ObjectMetaArgs(
                namespace=namespace,
                labels={ "app": "postgres" },
            ),
            spec=PodSpecArgs(
                volumes=[
                    VolumeArgs(
                        name=f"postgresdata",
                        persistent_volume_claim=PersistentVolumeClaimVolumeSourceArgs(
                            # NOTE: we need to hard set the name here.  If not
                            #       and we try and use the output from the
                            #       variables metadata then the system will
                            #       deadlock because Kubernetes is waiting for
                            #       the the PVC to have a pod attach to it before
                            #       returning but pulumi will not execute this
                            #       POD until the PVC returns ready
                            claim_name="postgres-pvc"
                        )
                    )
                ],
                containers=[
                    ContainerArgs(
                        image="postgres:16-alpine",
                        name="postgres",
                        image_pull_policy="IfNotPresent",
                        env_from=[
                            EnvFromSourceArgs(
                                config_map_ref= ConfigMapEnvSourceArgs(
                                    name=postgres_config_map.metadata["name"],
                                    optional=False
                                )
                            ),
                            EnvFromSourceArgs(
                                secret_ref=SecretEnvSourceArgs(
                                    name=postgres_secret_map.metadata["name"],
                                    optional=False
                                )
                            )
                        ],
                        volume_mounts=[
                            VolumeMountArgs(
                                name="postgresdata",
                                mount_path="/var/lib/postgresql/data",
                                read_only=False,
                                sub_path="postgres"
                            )
                        ],
                        ports=[
                            ContainerPortArgs(
                                container_port=5432,
                                host_port=5432,
                                protocol="TCP",
                            )
                        ],
                        liveness_probe=ProbeArgs(
                            exec_=ExecActionArgs(
                                command=[
                                  "psql",
                                  "-w",
                                  "-U",
                                  "postgres",
                                  "-d",
                                  "postgres",
                                  "-c",
                                  "SELECT 1"
                                ]
                            ),
                            initial_delay_seconds=10,
                            period_seconds=10,
                        ),
                        readiness_probe=ProbeArgs(
                            exec_=ExecActionArgs(
                                command=[
                                  "psql",
                                  "-w",
                                  "-U",
                                  "postgres",
                                  "-d",
                                  "postgres",
                                  "-c",
                                  "SELECT 1"
                                ]
                            ),
                            initial_delay_seconds=10,
                            period_seconds=10,
                        ),
                    ),
                ],
            ),
        ),
    )
)

# -----------------------------------------------------------------------------
# Postgres Service
# -----------------------------------------------------------------------------
postgres_service = Service(
    "wrilya-postgres-service",
    metadata=ObjectMetaArgs(
        name=f"postgres",
        namespace=namespace,
        labels={ "app": "postgres" }
    ),
    spec=ServiceSpecArgs(
        ports=[
            ServicePortArgs(
                port=5432,
                protocol="TCP",
                target_port=5432,
            )
        ],
        selector={ "app": "postgres" },
    )
)

# -----------------------------------------------------------------------------
# Redis Config
# -----------------------------------------------------------------------------
redis_config_map = ConfigMap(
    "wrilya-redis-config",
    metadata=ObjectMetaArgs(
        name="redis-config",
        namespace=namespace,
        labels={ "app": "redis" }
    ),
    data={
        "REDIS_HOST": f"redis.{namespace}.svc.cluster.local",
        "REDIS_PORT": "6379"
    }
)

pulumi.export('redis::config::id', redis_config_map.id)
pulumi.export('redis::config::name', redis_config_map.metadata["name"])

# -----------------------------------------------------------------------------
# Redis Deployment
# -----------------------------------------------------------------------------
redis_deployment = StatefulSet(
    "wrilya-redis",
    kind="Deployment",
    metadata=ObjectMetaArgs(
        name="redis",
        namespace=namespace,
        labels={ "app": "redis" }
    ),
    spec=StatefulSetSpecArgs(
        service_name="redis",
        selector=LabelSelectorArgs(
            match_labels={ "app": "redis" },
        ),
        replicas=1,
        template=PodTemplateSpecArgs(
            metadata=ObjectMetaArgs(
                namespace=namespace,
                labels={ "app": "redis" },
            ),
            spec=PodSpecArgs(
                containers=[
                    ContainerArgs(
                        image="redis:7-alpine",
                        name="redis",
                        image_pull_policy="IfNotPresent",
                        ports=[
                            ContainerPortArgs(
                                name="client",
                                container_port=6379,
                                host_port=6379,
                                protocol="TCP",
                            ),
                            ContainerPortArgs(
                                name="gossip",
                                container_port=16379,
                                host_port=16379,
                                protocol="TCP",
                            )
                        ],
                        liveness_probe=ProbeArgs(
                            tcp_socket=TCPSocketAction(
                                port="client"
                            ),
                            initial_delay_seconds=10,
                            period_seconds=10,
                            timeout_seconds=5,
                            failure_threshold=5,
                            success_threshold=1
                        ),
                        readiness_probe=ProbeArgs(
                            exec_=ExecActionArgs(
                                command=[
                                  "redis-cli",
                                  "ping"
                                ]
                            ),
                            initial_delay_seconds=20,
                            timeout_seconds=5,
                            period_seconds=3,
                        ),
                    ),
                ],
            ),
        ),
    )
)

# -----------------------------------------------------------------------------
# Redis Service
# -----------------------------------------------------------------------------
redis_service = Service(
    "wrilya-redis-service",
    metadata=ObjectMetaArgs(
        name="redis",
        namespace=namespace,
        labels={ "app": "redis" }
    ),
    spec=ServiceSpecArgs(
        ports=[
            ServicePortArgs(
                port=6379,
                protocol="TCP",
                target_port=6379,
            )
        ],
        selector={ "app": "redis" },
    )
)

# -----------------------------------------------------------------------------
# RabbitMQ Secret Generation
#
# If the secret doesn't already exist then we will create a new one.
# otherwise reuse the current secret.  This might not be the best way to
# manage/rotate secrets which will need to be revisited for production systems
# but for now it should be good enough while in fast development mode
# -----------------------------------------------------------------------------
rabbitmq_password = random.RandomPassword(
    "wrilya-rabbitmq-password-gen",
    length=16,
    special=False)

rabbitmq_secret = gcp.secretmanager.Secret(
    "wrilya-rabbitmq-password-sm",
    secret_id=f"wrilya-rabbitmq-password-{stack}",
    project=gcp_project,
    replication=gcp.secretmanager.SecretReplicationArgs(
        user_managed=gcp.secretmanager.SecretReplicationUserManagedArgs(
            replicas=[
                gcp.secretmanager.SecretReplicationUserManagedReplicaArgs(
                    location=gcp_region,
                ),
            ],
        ),
    )
)
rabbitmq_secret_version = gcp.secretmanager.SecretVersion(
    "wrilya-rabbitmq-secret-version-sm",
    secret=secret.id,
    secret_data=postgres_password.result)

# -----------------------------------------------------------------------------
# RabbitMQ Secret Map
# -----------------------------------------------------------------------------
rabbitmq_secret_map = Secret(
    "wrilya-rabbitmq-secret",
    metadata=ObjectMetaArgs(
        name="rabbitmq-secret",
        namespace=namespace,
        labels={ "app": "rabbitmq" }
    ),
    string_data={
        "RABBITMQ_PASS": postgres_password.result,
        "RABBITMQ_DEFAULT_PASS": postgres_password.result,
    }
)

pulumi.export('rabbitmq::secret::id', rabbitmq_secret_map.id)
pulumi.export('rabbitmq::secret::name', rabbitmq_secret_map.metadata["name"])


# -----------------------------------------------------------------------------
# RabbitMQ Config Map
#
# Default environment args that are not sensitive
# -----------------------------------------------------------------------------
rabbitmq_config_map = ConfigMap(
    "wrilya-rabbitmq-config",
    metadata=ObjectMetaArgs(
        name="rabbitmq-config",
        namespace=namespace,
        labels={ "app": "rabbitmq" }
    ),
    data={
        "RABBITMQ_HOST": f"rabbitmq.{namespace}.svc.cluster.local",
        "RABBITMQ_PORT": "5672", 
        "RABBITMQ_USER": "guest",
        "RABBITMQ_DEFAULT_USER": "guest",
    }
)

pulumi.export('rabbitmq::config::id', rabbitmq_config_map.id)
pulumi.export('rabbitmq::config::name', rabbitmq_config_map.metadata["name"])
 
# -----------------------------------------------------------------------------
# Rabbitmq Deployment
# -----------------------------------------------------------------------------
rabbitmq_deployment = StatefulSet(
    "wrilya-rabbitmq",
    kind="Deployment",
    metadata=ObjectMetaArgs(
        name="rabbitmq",
        namespace=namespace,
        labels={ "app": "rabbitmq" }
    ),
    spec=StatefulSetSpecArgs(
        service_name="rabbitmq",
        selector=LabelSelectorArgs(
            match_labels={ "app": "rabbitmq" },
        ),
        replicas=1,
        template=PodTemplateSpecArgs(
            metadata=ObjectMetaArgs(
                namespace=namespace,
                labels={ "app": "rabbitmq" },
            ),
            spec=PodSpecArgs(
                containers=[
                    ContainerArgs(
                        image="rabbitmq:alpine",
                        name="rabbitmq",
                        image_pull_policy="IfNotPresent",
                        ports=[
                            ContainerPortArgs(
                                container_port=5672,
                                host_port=5672,
                                protocol="TCP",
                            )
                        ],
                        env_from=[
                            EnvFromSourceArgs(
                                config_map_ref= ConfigMapEnvSourceArgs(
                                    name=rabbitmq_config_map.metadata["name"],
                                    optional=False
                                )
                            ),
                            EnvFromSourceArgs(
                                secret_ref=SecretEnvSourceArgs(
                                    name=rabbitmq_secret_map.metadata["name"],
                                    optional=False
                                )
                            )
                        ],
                        liveness_probe=ProbeArgs(
                            exec_=ExecActionArgs(
                                command=[
                                  "rabbitmq-diagnostics",
                                  "-q",
                                  "check_port_connectivity"
                                ]
                            ),
                            initial_delay_seconds=10,
                            timeout_seconds=5,
                            period_seconds=3,
                        ),
                        readiness_probe=ProbeArgs(
                            exec_=ExecActionArgs(
                                command=[
                                  "rabbitmq-diagnostics",
                                  "ping"
                                ]
                            ),
                            initial_delay_seconds=20,
                            timeout_seconds=5,
                            period_seconds=3,
                        ),
                    ),
                ],
            ),
        ),
    )
)

# -----------------------------------------------------------------------------
# Rabbitmq Service
# -----------------------------------------------------------------------------
rabbitmq_service = Service(
    "wrilya-rabbitmq-service",
    metadata=ObjectMetaArgs(
        name="rabbitmq",
        namespace=namespace,
        labels={ "app": "rabbitmq" }
    ),
    spec=ServiceSpecArgs(
        ports=[
            ServicePortArgs(
                port=5672,
                protocol="TCP",
                target_port=5672,
            )
        ],
        selector={ "app": "rabbitmq" },
    )
)

# -----------------------------------------------------------------------------
# Prometheus
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Grafana
# -----------------------------------------------------------------------------
