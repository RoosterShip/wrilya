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

# Currently Pulumi doesn't allow for creating "multi-region" repositories.  To
# get around this please create the repository directy in google cloud console
# and then run this script to cache off the needed info.

# For added fun it looks like artifactregistry docs don't seem to be working
# so for now we just going to let this be since frankly it doesn't really
# matter all that much.  If/When pulumi gets this working the following code
# can be used

# repo = gcp.artifactregistry.get_repository(repository_id="wrilya", project=gcp_project)
# 
# pulumi.export(f'artifact_repository::id', repo.id)
# pulumi.export(f'artifact_repository::name', repo.name)
# pulumi.export(f'artifact_repository::repository_id', repo.repository_id)

# Hard coded values
pulumi.export(f'artifact_repository::name', "wrilya")
pulumi.export(f'artifact_repository::repository_id', "wrilya")
pulumi.export(f'artifact_repository::path', "us-docker.pkg.dev/rooster-ship-framework/wrilya")
