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

#------------------------------------------------------------------------------
# Imports
#------------------------------------------------------------------------------
import pulumi # type: ignore
import pulumi_gcp as gcp  # type: ignore

#------------------------------------------------------------------------------
# Global Config Setup
#------------------------------------------------------------------------------
stack = pulumi.get_stack()
provider_cfg = pulumi.Config("gcp")
gcp_project = provider_cfg.require("project")
gcp_region = provider_cfg.get("region", "us-central1")
config = pulumi.Config()
nodes_per_zone = config.get_int("nodesPerZone", 1)
node_type = config.get("nodeType", "ec2-small")

#------------------------------------------------------------------------------
# Network Setup
#
# Creates the VPN we will be deploying the cluster on
#------------------------------------------------------------------------------

wrilya_gke_network = gcp.compute.Network(
    "wrilya-gke-network",
    auto_create_subnetworks=False,
    description=f"A virtual network for the Wrilya {stack} GKE cluster"
)

pulumi.export("network::name", wrilya_gke_network.name)
pulumi.export("network::id", wrilya_gke_network.id)
pulumi.export("network::urn", wrilya_gke_network.urn)
pulumi.export("network::link", wrilya_gke_network.self_link)

#------------------------------------------------------------------------------
# Subnet Setup
#
# Create the subnet IP range to use for the deployed cluster
#------------------------------------------------------------------------------
wrilya_gke_subnet = gcp.compute.Subnetwork(
    "wrilya-gke-subnet",
    ip_cidr_range="10.128.0.0/12",
    network=wrilya_gke_network.id,
    private_ip_google_access=True,
    region=gcp_region,
)

pulumi.export("network::subnet::name", wrilya_gke_subnet.name)
pulumi.export("network::subnet::id", wrilya_gke_subnet.id)

# -----------------------------------------------------------------------------
# Router and NAT
#
# Used to allow the cluster to talk to the internet.  NOTE:  This is for egress
# requests from the cluster to some other service like Discord or a blockchain
# -----------------------------------------------------------------------------
wrilya_gke_router = gcp.compute.Router(
    "wrilya-gke-router",
    network=wrilya_gke_network.id,
    region=wrilya_gke_subnet.region
)

pulumi.export("network::router::name", wrilya_gke_router.name)
pulumi.export("network::router::id", wrilya_gke_router.id)

wrilya_gke_nat = gcp.compute.RouterNat(
    "wrilya-gke-nat",
    region=gcp_region,
    router=wrilya_gke_router.name,
    nat_ip_allocate_option="AUTO_ONLY",
    source_subnetwork_ip_ranges_to_nat="ALL_SUBNETWORKS_ALL_IP_RANGES",
    log_config=gcp.compute.RouterNatLogConfigArgs(
        enable=True,
        filter="ERRORS_ONLY",
    )
)

pulumi.export("network::nat::name", wrilya_gke_nat.name)
pulumi.export("network::nat::id", wrilya_gke_nat.id)
 
# -----------------------------------------------------------------------------
# Setup the IP Range for VPC Peering.
#
# Honestly I am not sure if this is needed or if it is hold over from some
# generated scripts with trying to get the cluster to communicate with CloudSQL
# -----------------------------------------------------------------------------

wrilya_ip_range = gcp.compute.GlobalAddress(
    "wrilya-gke-ip-range",
    purpose="VPC_PEERING",
    address_type="INTERNAL",
    prefix_length=16,
    network=wrilya_gke_network.id
    )

pulumi.export("network::range::name", wrilya_ip_range.name)
pulumi.export("network::range::id", wrilya_ip_range.id)

# -----------------------------------------------------------------------------
# Network Connection
#
# Honestly I am not sure if this is needed or if it is hold over from some
# generated scripts with trying to get the cluster to communicate with CloudSQL
# -----------------------------------------------------------------------------

wrilya_connection = gcp.servicenetworking.Connection(
    "wrilya-gke-connection",
    network=wrilya_gke_network.id,
    service="servicenetworking.googleapis.com",
    reserved_peering_ranges=[wrilya_ip_range.name])

pulumi.export("network::connection::id", wrilya_connection.id)

# -----------------------------------------------------------------------------
# GKE Cluster Setup
#
# Creates the actual GKE Cluster.  Most settings are coming from the pulumi
# template and might not be correct but they work for now and when more resources
# (time or people) are available this should be reviewed for correctness.
# -----------------------------------------------------------------------------
wrilya_gke_cluster = gcp.container.Cluster(
    "wrilya-gke-cluster",
    addons_config=gcp.container.ClusterAddonsConfigArgs(
        dns_cache_config=gcp.container.ClusterAddonsConfigDnsCacheConfigArgs(
            enabled=True
        ),
    ),
    binary_authorization=gcp.container.ClusterBinaryAuthorizationArgs(
        evaluation_mode="PROJECT_SINGLETON_POLICY_ENFORCE"
    ),
    datapath_provider="ADVANCED_DATAPATH",
    description="The Wrilya GKE cluster",
    initial_node_count=1,
    ip_allocation_policy=gcp.container.ClusterIpAllocationPolicyArgs(
        cluster_ipv4_cidr_block="/14",
        services_ipv4_cidr_block="/20"
    ),
    location=gcp_region,
    master_authorized_networks_config=gcp.container.ClusterMasterAuthorizedNetworksConfigArgs(
        cidr_blocks=[gcp.container.ClusterMasterAuthorizedNetworksConfigCidrBlockArgs(
            cidr_block="0.0.0.0/0",
            display_name="All networks"
        )]
    ),
    network=wrilya_gke_network.name,
    networking_mode="VPC_NATIVE",
    private_cluster_config=gcp.container.ClusterPrivateClusterConfigArgs(
        enable_private_nodes=True,
        enable_private_endpoint=False,
        master_ipv4_cidr_block="10.100.0.0/28"
    ),
    remove_default_node_pool=True,
    release_channel=gcp.container.ClusterReleaseChannelArgs(
        channel="STABLE"
    ),
    subnetwork=wrilya_gke_subnet.name,
    workload_identity_config=gcp.container.ClusterWorkloadIdentityConfigArgs(
        workload_pool=f"{gcp_project}.svc.id.goog"
    )
)

pulumi.export("cluster::name", wrilya_gke_cluster.name)
pulumi.export("cluster::id", wrilya_gke_cluster.id)

# Write the name of the cluster so I can load it up via make file commands
def write_cluster_name(name):
    f = open(f"../{stack}.cluster", "w")
    f.write(name)
    f.close()

wrilya_gke_cluster.name.apply(lambda name: write_cluster_name(name))


# -----------------------------------------------------------------------------
# Cluster NodePool Service Account
#
# A service account for the cluster.  At some point I would like to switch
# to useing Workload Identity but that can wait until we have more resources.
# -----------------------------------------------------------------------------
wrilya_gke_nodepool_sa = gcp.serviceaccount.Account(
    "wrilya-gke-nodepool-sa",
    account_id=f"wrilya-gke-np-sa-{stack}",
    display_name="Nodepool Service Account"
)

# We need to explicily give it access to read from the artifact repository
wrilya_gke_nodepool_sa_iam_binding = gcp.artifactregistry.RepositoryIamBinding(
    "wrilya-gke-nodepool-sa-iam-binding",
    repository="wrilya",
    project=gcp_project,
    location=gcp_region,
    role="roles/artifactregistry.reader",
    members=[wrilya_gke_nodepool_sa.email.apply(lambda email: f"serviceAccount:{email}")])

pulumi.export("cluster::sa", wrilya_gke_nodepool_sa)

# -----------------------------------------------------------------------------
# Cluster NodePool 
#
# The default node pool isn't that great so we want to manage this ourselves.
# Again this is part of the kubenetes cluster
# -----------------------------------------------------------------------------
wrilya_gke_nodepool = gcp.container.NodePool(
    "wrilya-gke-nodepool",
    cluster=wrilya_gke_cluster.id,
    node_count=nodes_per_zone,
    node_config=gcp.container.NodePoolNodeConfigArgs(
        oauth_scopes=["https://www.googleapis.com/auth/cloud-platform"],
        service_account=wrilya_gke_nodepool_sa.email,
        machine_type=node_type,
    )
)

# -----------------------------------------------------------------------------
# Cluster Kube Config 
# -----------------------------------------------------------------------------

# Build a Kubeconfig to access the cluster
wrilya_cluster_kubeconfig = pulumi.Output.all(
    wrilya_gke_cluster.master_auth.cluster_ca_certificate,
    wrilya_gke_cluster.endpoint,
    wrilya_gke_cluster.name).apply(lambda l:
    f"""apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: {l[0]}
    server: https://{l[1]}
  name: {l[2]}
contexts:
- context:
    cluster: {l[2]}
    user: {l[2]}
  name: {l[2]}
current-context: {l[2]}
kind: Config
preferences: {{}}
users:
- name: {l[2]}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: gke-gcloud-auth-plugin
      installHint: Install gke-gcloud-auth-plugin for use with kubectl by following
        https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
      provideClusterInfo: true
""")

# Export some values for use elsewhere
pulumi.export("cluster::kubeconfig", wrilya_cluster_kubeconfig)
