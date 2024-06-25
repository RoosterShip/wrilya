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
import pulumi_kubernetes as kubernetes #type: ignore
from pulumi_gcp.compute import GlobalAddress # type: ignore
from pulumi_gcp.dns import ManagedZone #type: ignore
from pulumi_gcp.dns import RecordSet #type: ignore
from pulumi_kubernetes.yaml import ConfigGroup # type: ignore
from pulumi_kubernetes.networking.v1 import Ingress #type: ignore
from pulumi_kubernetes.networking.v1 import IngressSpecArgs #type: ignore
from pulumi_kubernetes.networking.v1 import IngressRuleArgs #type: ignore
from pulumi_kubernetes.networking.v1 import HTTPIngressRuleValueArgs #type: ignore
from pulumi_kubernetes.networking.v1 import HTTPIngressPathArgs #type: ignore
from pulumi_kubernetes.networking.v1 import IngressBackendArgs #type: ignore
from pulumi_kubernetes.networking.v1 import IngressServiceBackendArgs #type: ignore
from pulumi_kubernetes.networking.v1 import ServiceBackendPortArgs #type: ignore
from pulumi_kubernetes.meta.v1 import ObjectMetaArgs #type: ignore

# -----------------------------------------------------------------------------
# Global Configuration Setup
# -----------------------------------------------------------------------------
stack = pulumi.get_stack()
org = pulumi.get_organization()
config = pulumi.Config()
namespace = config.get("namespace", "dev")
subdomain = config.get("subdomain", "dev")

# -----------------------------------------------------------------------------
# Create Global Address for Ingress
# -----------------------------------------------------------------------------
global_static_ip = GlobalAddress("wrilya-static-ip")

# -----------------------------------------------------------------------------
# Setup the Managed Cert
#
# We will be doing SSL termination at the ingress controller level
# -----------------------------------------------------------------------------
# Expose the Deployment as a Kubernetes Service
managed_zone = ManagedZone.get("wrilya.com", id="wrilya-com")
a_record = RecordSet(
  "a-record",
  name=f"{subdomain}.wrilya.com.",
  type="A",
  ttl=300,
  managed_zone=managed_zone.name,
  rrdatas=[global_static_ip.address]
)

managed_cert_cmd = f"""
apiVersion: networking.gke.io/v1
kind: ManagedCertificate
metadata:
  name: wrilya-managed-cert
  namespace: {namespace}
spec:
  domains:
    - {subdomain}.wrilya.com
"""

managed_cert = ConfigGroup(
    "managed-cert",
    yaml=[managed_cert_cmd]
)

# -----------------------------------------------------------------------------
# HTTP -> HTTPS auto redirection
# -----------------------------------------------------------------------------
http_to_https_cmd = f"""
apiVersion: networking.gke.io/v1beta1
kind: FrontendConfig
metadata:
  name: http-to-https
  namespace: {namespace}
spec:
  redirectToHttps:
    enabled: true
    responseCodeName: MOVED_PERMANENTLY_DEFAULT
"""

http_to_https = ConfigGroup(
    "http-to-https",
    yaml=[http_to_https_cmd]
)
 
# -----------------------------------------------------------------------------
# Ingress configuration
# -----------------------------------------------------------------------------
wrilya_ingress = Ingress(
    "wrilya-ingress",
    kind="Ingress",
    metadata=ObjectMetaArgs(
        name="wrilya-ingress",
        namespace=namespace,
        annotations={
            "kubernetes.io/ingress.global-static-ip-name": global_static_ip.name,
            "networking.gke.io/managed-certificates": f"wrilya-managed-cert",
            "networking.gke.io/v1beta1.FrontendConfig": "http-to-https",
            "ingressClassName": "gce" 
        },
    ),
    spec=IngressSpecArgs(
        rules=[
            IngressRuleArgs(
                http=HTTPIngressRuleValueArgs(
                    paths=[
                        HTTPIngressPathArgs(
                            path="/api/*",
                            path_type="ImplementationSpecific",
                            backend=IngressBackendArgs(
                                service=IngressServiceBackendArgs(
                                    name="wrilya",
                                    port=ServiceBackendPortArgs(
                                        number=4000
                                    )
                                ) 
                            )
                        ),
                        HTTPIngressPathArgs(
                            path="/*",
                            path_type="ImplementationSpecific",
                            backend=IngressBackendArgs(
                                service=IngressServiceBackendArgs(
                                    name="client",
                                    port=ServiceBackendPortArgs(
                                        number=80
                                    )
                                ) 
                            )
                        ),
                    ]
                )
            ),
        ]
    )
)

# Export some values for use elsewhere
pulumi.export('global_static_ip_address', global_static_ip.address)
pulumi.export('dns_record_name', a_record.name)