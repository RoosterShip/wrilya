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

# Get some provider-namespaced configuration values
provider_cfg = pulumi.Config("gcp")
gcp_project = provider_cfg.require("project")
gcp_region = provider_cfg.get("region", "us-central1")

# Get some additional configuration values
config = pulumi.Config()
nodes_per_zone = config.get_int("nodesPerZone", 1)
node_type = config.get("nodeType", "ec2-small")

#------------------------------------------------------------------------------
# Network Setup
#------------------------------------------------------------------------------

# Create a new network
wrilya_gke_network = gcp.compute.Network(
    f"wrilya-gke-network-{stack}",
    auto_create_subnetworks=False,
    description=f"A virtual network for the Wrilya {stack} GKE cluster"
)

pulumi.export("network::name", wrilya_gke_network.name)
pulumi.export("network::id", wrilya_gke_network.id)
pulumi.export("network::urn", wrilya_gke_network.urn)
pulumi.export("network::link", wrilya_gke_network.self_link)

#------------------------------------------------------------------------------
# Subnet Setup
#------------------------------------------------------------------------------

# Create a subnet in the new network
wrilya_gke_subnet = gcp.compute.Subnetwork(
    f"wrilya-gke-subnet-{stack}",
    ip_cidr_range="10.128.0.0/12",
    network=wrilya_gke_network.id,
    private_ip_google_access=True
)

pulumi.export("network::subnet::name", wrilya_gke_subnet.name)
pulumi.export("network::subnet::id", wrilya_gke_subnet.id)

# -----------------------------------------------------------------------------
# GKE Cluster Setup
# -----------------------------------------------------------------------------

# Create a cluster in the new network and subnet
wrilya_gke_cluster = gcp.container.Cluster(
    f"wrilya-gke-cluster-{stack}",
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

# -----------------------------------------------------------------------------
# Cluster NodePool Service Account
# -----------------------------------------------------------------------------

# Create a GCP service account for the nodepool
wrilya_gke_nodepool_sa = gcp.serviceaccount.Account(
    f"wrilya-gke-nodepool-sa-{stack}",
    #account_id=pulumi.Output.concat(wrilya_gke_cluster.name, f"-sa"),
    account_id=f"wrilya-gke-np-sa-{stack}",
    display_name="Nodepool Service Account"
)

pulumi.export("cluster::sa", wrilya_gke_nodepool_sa)

# -----------------------------------------------------------------------------
# Cluster NodePool 
# -----------------------------------------------------------------------------

# Create a nodepool for the cluster
wrilya_gke_nodepool = gcp.container.NodePool(
    f"wrilya-gke-nodepool-{stack}",
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
