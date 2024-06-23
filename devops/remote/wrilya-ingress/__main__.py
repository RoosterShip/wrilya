# -----------------------------------------------------------------------------
# Imports
# -----------------------------------------------------------------------------
import pulumi #type: ignore
import pulumi_gcp as gcp #type: ignore
import pulumi_kubernetes as kubernetes #type: ignore
# from pulumi_kubernetes.apps.v1 import *
# from pulumi_kubernetes.core.v1 import *
# from pulumi_kubernetes.meta.v1 import *
# from pulumi_kubernetes.networking.v1 import *

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
global_static_ip = GlobalAddress(f"wrilya-static-ip-{stack}")

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

#managed_certificate = gcp.certificatemanager.Certificate("managed-certificate",
#    managed=gcp.certificatemanager.CertificateManagedArgs(
#        domains=["wrilya.com", "dev.wrilya.com"]  # Replace with your domain
#    ))

managed_cert_cmd = f"""
apiVersion: networking.gke.io/v1
kind: ManagedCertificate
metadata:
  name: wrilya-managed-cert-{stack}
  namespace: {namespace}
spec:
  domains:
    - {subdomain}.wrilya.com
"""

managed_cert = ConfigGroup(
    "managed-cert",
    yaml=[managed_cert_cmd]
)

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
 
 
wrilya_ingress = Ingress(
    "wrilya-ingress",
    kind="Ingress",
    metadata=ObjectMetaArgs(
        name="wrilya-ingress",
        namespace=namespace,
        annotations={
            "kubernetes.io/ingress.global-static-ip-name": global_static_ip.name,
            "networking.gke.io/managed-certificates": f"wrilya-managed-cert-{stack}",
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
    #spec={
    #    "defaultBackend": {
    #        "service": {
    #            #"name": webserverservice.metadata["name"],
    #            "name": "rsf-admin",
    #            "port": {"number": 80},
    #        }
    #    }
    #}
)

# Export some values for use elsewhere
pulumi.export('global_static_ip_address', global_static_ip.address)
pulumi.export('dns_record_name', a_record.name)
# pulumi.export('certificate_name', managed_certificate.name)
# pulumi.export("serviceName", webserverservice.metadata.name)