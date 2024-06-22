# -----------------------------------------------------------------------------
# Imports
# -----------------------------------------------------------------------------
import pulumi
import pulumi_gcp as gcp
import pulumi_kubernetes as kubernetes
from pulumi_gcp.compute import GlobalAddress
from pulumi_gcp.dns import *
from pulumi_kubernetes.apps.v1 import *
from pulumi_kubernetes.core.v1 import *
from pulumi_kubernetes.meta.v1 import *
from pulumi_kubernetes.networking.v1 import *
from pulumi_kubernetes.yaml import *

stack = pulumi.get_stack()
org = pulumi.get_organization()
config = pulumi.Config()
k8sNamespace = config.get("namespace", "dev")

admin_labels = {
    "rsf-admin": "true",
}

wrilya_labels = {
    "wrilya-client": "true",
}

global_static_ip = GlobalAddress("rsf-static-ip-"+k8sNamespace)

# Expose the Deployment as a Kubernetes Service
managed_zone = ManagedZone.get("wrilya.com", id="wrilya-com")
a_record = RecordSet(
  "a-record",
  name="dev.wrilya.com.",
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
  name: rsf-managed-cert
  namespace: {k8sNamespace}
spec:
  domains:
    - dev.wrilya.com
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
  namespace: {k8sNamespace}
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
        namespace=k8sNamespace,
        annotations={
            "kubernetes.io/ingress.global-static-ip-name": global_static_ip.name,
            "networking.gke.io/managed-certificates": "rsf-managed-cert",
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
                            path="/client",
                            path_type="ImplementationSpecific",
                            backend=IngressBackendArgs(
                                service=IngressServiceBackendArgs(
                                    name="wrilya-client",
                                    port=ServiceBackendPortArgs(
                                        number=80
                                    )
                                ) 
                            )
                        ),
                        HTTPIngressPathArgs(
                            path="/client/*",
                            path_type="ImplementationSpecific",
                            backend=IngressBackendArgs(
                                service=IngressServiceBackendArgs(
                                    name="wrilya-client",
                                    port=ServiceBackendPortArgs(
                                        number=80
                                    )
                                ) 
                            )
                        ),
                        HTTPIngressPathArgs(
                            path="/admin",
                            path_type="ImplementationSpecific",
                            backend=IngressBackendArgs(
                                service=IngressServiceBackendArgs(
                                    name="rsf-admin",
                                    port=ServiceBackendPortArgs(
                                        number=80
                                    )
                                ) 
                            )
                        ),
                        HTTPIngressPathArgs(
                            path="/admin/*",
                            path_type="ImplementationSpecific",
                            backend=IngressBackendArgs(
                                service=IngressServiceBackendArgs(
                                    name="rsf-admin",
                                    port=ServiceBackendPortArgs(
                                        number=80
                                    )
                                ) 
                            )
                        ),
                        HTTPIngressPathArgs(
                            path="/*",
                            path_type="ImplementationSpecific",
                            backend=IngressBackendArgs(
                                service=IngressServiceBackendArgs(
                                    name="wrilya-site",
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