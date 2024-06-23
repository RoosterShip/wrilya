# -----------------------------------------------------------------------------
# Imports
# -----------------------------------------------------------------------------
import pulumi #type: ignore
import pulumi_gcp as gcp #type: ignore
from pulumi_kubernetes.apps.v1 import Deployment, DeploymentSpecArgs #type: ignore
from pulumi_kubernetes.core.v1 import ConfigMap, ConfigMapEnvSourceArgs #type: ignore
from pulumi_kubernetes.core.v1 import ContainerArgs, ContainerPortArgs #type: ignore
from pulumi_kubernetes.core.v1 import HTTPGetActionArgs #type: ignore
from pulumi_kubernetes.core.v1 import PodTemplateSpecArgs, PodSpecArgs #type: ignore
from pulumi_kubernetes.core.v1 import ProbeArgs #type: ignore
from pulumi_kubernetes.core.v1.outputs import EnvVar #type: ignore
from pulumi_kubernetes.core.v1 import Service, ServiceSpecArgs, ServicePortArgs #type: ignore
from pulumi_kubernetes.meta.v1 import LabelSelectorArgs #type: ignore
from pulumi_kubernetes.meta.v1 import ObjectMetaArgs #type: ignore
from pulumi_kubernetes.core.v1 import Secret, SecretEnvSourceArgs #type: ignore
from pulumi_kubernetes.core.v1 import EnvFromSourceArgs #type: ignore

# from pulumi_kubernetes.apps.v1 import *
# from pulumi_kubernetes.core.v1 import *
# from pulumi_kubernetes.meta.v1 import *
# from pulumi_kubernetes.networking.v1 import *
# from pulumi_kubernetes.yaml import *

# -----------------------------------------------------------------------------
# Global Configuration Setup
# -----------------------------------------------------------------------------

# Get some values from the Pulumi stack configuration, or use defaults
stack = pulumi.get_stack()
provider_cfg = pulumi.Config("gcp")
gcp_project = provider_cfg.require("project")
gcp_region = provider_cfg.get("region", "us-central1")
org = pulumi.get_organization()
config = pulumi.Config()
namespace = config.get("namespace", "default")
replicas = config.get_int("replicas", 1)
chain_id = config.get("chain_id")
chain_rpc = config.get("chain_rpc")

# These should come from the world.json file in contracts but give then whole python
# env thing I figured it might just easier read them from the config first and then
# figure out a way to load in that json file later
world_address = config.get("world_address")
world_block = config.get("world_block")
discord_token = config.require_secret("discordToken")
secret_key_base = config.require_secret("secretKeyBase")

# -----------------------------------------------------------------------------
# Imported Stack
# -----------------------------------------------------------------------------
wrilya_env_ref = pulumi.StackReference(f"{org}/wrilya-env/{stack}")
postgres_config = wrilya_env_ref.get_output("postgres::config::name")
postgres_secret = wrilya_env_ref.get_output("postgres::secret::name")
rabbitmq_config = wrilya_env_ref.get_output('rabbitmq::config::name')
redis_config = wrilya_env_ref.get_output('redis::config::name')

# -----------------------------------------------------------------------------
# Indexer
#
# Reads the blockchain and publishes changes to database.
# -----------------------------------------------------------------------------
indexer_labels = {
    "app": "indexer"
}

indexer_deployment = Deployment(
    f"indexer-{stack}",
    kind="Deployment",
    metadata=ObjectMetaArgs(
        name="indexer",
        namespace=namespace
    ),
    spec=DeploymentSpecArgs(
        selector=LabelSelectorArgs(
            match_labels=indexer_labels,
        ),
        replicas=1,
        template=PodTemplateSpecArgs(
            metadata=ObjectMetaArgs(
                labels=indexer_labels,
            ),
            spec=PodSpecArgs(
                containers=[
                    ContainerArgs(
                        image="us-central1-docker.pkg.dev/rooster-ship-framework/wrilya/store-indexer:latest",
                        image_pull_policy="Always",
                        name="indexer",
                        working_dir="/app/packages/store-indexer",
                        command=["pnpm", "start:postgres-decoded"],
                        ports=[
                            # Open up the wrilya port
                            ContainerPortArgs(
                                container_port=3001,
                                host_port=3001,
                                protocol="TCP",
                            ),
                        ],
                        env=[
                          EnvVar(
                            name="RPC_HTTP_URL",
                            value=chain_rpc
                          ),
                          EnvVar(
                            name="FOLLOW_BLOCK_TAG",
                            value="latest",
                          ),
                          EnvVar(
                            name="START_BLOCK",
                            value=world_block,
                          ),
                          EnvVar(
                            name="STORE_ADDRESS",
                            value=world_address
                          ),
                          EnvVar(
                            name="POLLING_INTERVAL",
                            value="500",
                          ),
                        ],
                        env_from=[
                            EnvFromSourceArgs(
                                secret_ref=SecretEnvSourceArgs(
                                    name=postgres_secret,
                                    optional=False
                                )
                            )
                        ]
                    )
                ],
            ),
        ),
    )
)

# -----------------------------------------------------------------------------
# indexer Service
# -----------------------------------------------------------------------------
indexer_service = Service(
    resource_name=f"indexer-service-{stack}",
    opts=pulumi.ResourceOptions(depends_on=[indexer_deployment]),
    metadata=ObjectMetaArgs(
        name="indexer",
        namespace=namespace,
        labels=indexer_labels
    ),
    spec=ServiceSpecArgs(
        ports=[
            ServicePortArgs(
                name="indexer-port",
                port=3001,
                protocol="TCP",
                target_port=3001,
            )
        ],
        selector=indexer_labels
    )
)


# -----------------------------------------------------------------------------
# Wrilya
#
# Deploy the main Wrilya Server
# -----------------------------------------------------------------------------
wrilya_labels = {
    "app": "wrilya"
}

wrilya_deployment = Deployment(
    f"wrilya-{stack}",
    kind="Deployment",
    opts=pulumi.ResourceOptions(depends_on=[indexer_deployment, indexer_service]),
    metadata=ObjectMetaArgs(
        name="wrilya",
        namespace=namespace
    ),
    spec=DeploymentSpecArgs(
        selector=LabelSelectorArgs(
            match_labels=wrilya_labels,
        ),
        replicas=1,
        template=PodTemplateSpecArgs(
            metadata=ObjectMetaArgs(
                labels=wrilya_labels,
            ),
            spec=PodSpecArgs(
                containers=[
                    ContainerArgs(
                        image="us-central1-docker.pkg.dev/rooster-ship-framework/wrilya/wrilya:latest",
                        #command=["sleep", "infinity"],
                        image_pull_policy="Always",
                        name="relayer",
                        ports=[
                            # Open up the wrilya port
                            ContainerPortArgs(
                                container_port=4000,
                                host_port=4000,
                                protocol="TCP",
                            ),
                        ],
                        liveness_probe=ProbeArgs(
                            http_get=HTTPGetActionArgs(
                                port=4000,
                                path="/api/status/healthy",
                            ),
                            initial_delay_seconds=10,
                            period_seconds=10,
                        ),
                        readiness_probe=ProbeArgs(
                            http_get=HTTPGetActionArgs(
                                port=4000,
                                path="/api/status/ready",
                            ),
                            initial_delay_seconds=10,
                            period_seconds=10,
                        ),
                        env=[
                          EnvVar(
                            name="CHAIN_URL",
                            value=chain_rpc
                          ),
                          EnvVar(
                            name="CHAIN_ID",
                            value=chain_id,
                          ),
                          EnvVar(
                            name="NOTIFICATION_QUEUE",
                            value="@wrilya_notification_queue",
                          ),
                          EnvVar(
                            name="DISCORD_TOKEN",
                            value=discord_token.apply(lambda dt: f"{dt}"),
                          ),
                          EnvVar(
                            name="SECRET_KEY_BASE",
                            value=secret_key_base.apply(lambda skb: f"{skb}"),
                          ),
                          EnvVar(
                            name="WRILYA_DATABASE",
                            value=f"wrilya_{namespace}"
                          )
                        ],
                        env_from=[
                            # Postgres Info
                            EnvFromSourceArgs(
                                config_map_ref= ConfigMapEnvSourceArgs(
                                    name=postgres_config,
                                    optional=False
                                )
                            ),
                            EnvFromSourceArgs(
                                secret_ref=SecretEnvSourceArgs(
                                    name=postgres_secret,
                                    optional=False
                                )
                            ),
                            # RabbitMQ Info
                            EnvFromSourceArgs(
                                config_map_ref= ConfigMapEnvSourceArgs(
                                    name=rabbitmq_config,
                                    optional=False
                                )
                            ),
                            # Redis Info
                            EnvFromSourceArgs(
                                config_map_ref= ConfigMapEnvSourceArgs(
                                    name=redis_config,
                                    optional=False
                                )
                            ),
                        ],
                    )
                ],
            ),
        ),
    )
)

# -----------------------------------------------------------------------------
# Wrilya Service
# -----------------------------------------------------------------------------
wrilya_service = Service(
    resource_name=f"wrilya-service-{stack}",
    opts=pulumi.ResourceOptions(depends_on=[wrilya_deployment]),
    metadata=ObjectMetaArgs(
        name="wrilya",
        namespace=namespace,
        labels=wrilya_labels
    ),
    spec=ServiceSpecArgs(
        ports=[
            ServicePortArgs(
                name="wrilya-port",
                port=4000,
                protocol="TCP",
                target_port=4000,
            )
        ],
        selector=wrilya_labels
    )
)

# -----------------------------------------------------------------------------
# Relayer
#
# Notifies the system when an onchain event happens that I need to perform
# an offchain operations for.
# -----------------------------------------------------------------------------
relayer_labels = {
    "app": "relayer"
}

relayer_deployment = Deployment(
    f"relayer-{stack}",
    kind="Deployment",
    opts=pulumi.ResourceOptions(depends_on=[wrilya_deployment, wrilya_service]),
    metadata=ObjectMetaArgs(
        name="relayer",
        namespace=namespace
    ),
    spec=DeploymentSpecArgs(
        selector=LabelSelectorArgs(
            match_labels=relayer_labels,
        ),
        replicas=1,
        template=PodTemplateSpecArgs(
            metadata=ObjectMetaArgs(
                labels=relayer_labels,
            ),
            spec=PodSpecArgs(
                containers=[
                    ContainerArgs(
                        image="us-central1-docker.pkg.dev/rooster-ship-framework/wrilya/relayer:latest",
                        #command=["sleep", "infinity"],
                        image_pull_policy="Always",
                        name="relayer",
                        ports=[
                            # Open up the wrilya port
                            ContainerPortArgs(
                                container_port=6000,
                                host_port=6000,
                                protocol="TCP",
                            ),
                        ],
                        liveness_probe=ProbeArgs(
                            http_get=HTTPGetActionArgs(
                                port=6000,
                                path="/healthy",
                            ),
                            initial_delay_seconds=10,
                            period_seconds=10,
                        ),
                        readiness_probe=ProbeArgs(
                            http_get=HTTPGetActionArgs(
                                port=6000,
                                path="/ready",
                            ),
                            initial_delay_seconds=10,
                            period_seconds=10,
                        ),

                        env=[
                          EnvVar(
                            name="CHAIN_ID",
                            value=chain_id,
                          ),
                          EnvVar(
                            name="NOTIFICATION_QUEUE",
                            value="@wrilya_notification_queue",
                          ),
                        ],
                        env_from=[
                            EnvFromSourceArgs(
                                config_map_ref= ConfigMapEnvSourceArgs(
                                    name=rabbitmq_config,
                                    optional=False
                                )
                            ),
                            EnvFromSourceArgs(
                                config_map_ref= ConfigMapEnvSourceArgs(
                                    name=redis_config,
                                    optional=False
                                )
                            ),
                        ],
                    )
                ],
            ),
        ),
    )
)

# -----------------------------------------------------------------------------
# relayer Service
# -----------------------------------------------------------------------------
relayer_service = Service(
    resource_name=f"relayer-service-{stack}",
    opts=pulumi.ResourceOptions(depends_on=[relayer_deployment]),
    metadata=ObjectMetaArgs(
        name="relayer",
        namespace=namespace,
        labels=relayer_labels
    ),
    spec=ServiceSpecArgs(
        ports=[
            ServicePortArgs(
                name="relayer-port",
                port=6000,
                protocol="TCP",
                target_port=6000,
            )
        ],
        selector=relayer_labels
    )
)

# -----------------------------------------------------------------------------
# Client Deployment
#
# Just a simple NGNIX deployment of the phaser client.  In the future we should
# move this to a more CDN based system but for now this should be fine
# -----------------------------------------------------------------------------

client_labels = {
    "app": "client"
}

client_deployment = Deployment(
    f"client-{stack}",
    kind="Deployment",
    metadata=ObjectMetaArgs(
        name="client",
        namespace=namespace
    ),
    spec=DeploymentSpecArgs(
        selector=LabelSelectorArgs(
            match_labels=client_labels,
        ),
        replicas=1,
        template=PodTemplateSpecArgs(
            metadata=ObjectMetaArgs(
                labels=client_labels,
            ),
            spec=PodSpecArgs(
                containers=[
                    ContainerArgs(
                        image=f"{gcp_region}-docker.pkg.dev/rooster-ship-framework/wrilya/client:latest",
                        image_pull_policy="Always",
                        name="client",
                        liveness_probe=ProbeArgs(
                            http_get=HTTPGetActionArgs(
                                port=80,
                                path="/",
                            ),
                            initial_delay_seconds=10,
                            period_seconds=10,
                        ),
                        readiness_probe=ProbeArgs(
                            http_get=HTTPGetActionArgs(
                                port=80,
                                path="/",
                            ),
                            initial_delay_seconds=10,
                            period_seconds=10,
                        ),
                        ports=[
                            # Open up the wrilya port
                            ContainerPortArgs(
                                container_port=80,
                                host_port=80,
                                protocol="TCP",
                            ),
                        ],
                    )
                ],
            ),
        ),
    )
)

# -----------------------------------------------------------------------------
# Client Service
# -----------------------------------------------------------------------------
client_service = Service(
    resource_name=f"client-service-{stack}",
    metadata=ObjectMetaArgs(
        name="client",
        namespace=namespace,
        labels=client_labels
    ),
    spec=ServiceSpecArgs(
        ports=[
            ServicePortArgs(
                name="client-port",
                port=80,
                protocol="TCP",
                target_port=80,
            )
        ],
        selector=client_labels
    )
)

