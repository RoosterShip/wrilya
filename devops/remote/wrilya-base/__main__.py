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

# Get some provider-namespaced configuration values
provider_cfg = pulumi.Config("gcp")
gcp_project = provider_cfg.require("project")
gcp_region = provider_cfg.get("region", "us-central1")

# -----------------------------------------------------------------------------
# Setup Artifact Repository
# -----------------------------------------------------------------------------

artifact_repository = gcp.artifactregistry.Repository("artifactRepository",
    format="DOCKER",
    project=gcp_project,
    location=gcp_region,
    repository_id="wrilya",
    description="Project Wrilya General Registry"  # Provide a description for your repository.
)

# Hard coded values
pulumi.export(f'artifact_repository::id', artifact_repository.id)
pulumi.export(f'artifact_repository::name', artifact_repository.name)
pulumi.export(f'artifact_repository::repository_id', artifact_repository.repository_id)
pulumi.export(f'artifact_repository::path', f"us-{gcp_region}-docker.pkg.dev/rooster-ship-framework/wrilya")
