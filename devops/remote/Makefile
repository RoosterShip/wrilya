#------------------------------------------------------------------------------
# Make setup
#------------------------------------------------------------------------------
.PHONY: help up.dev dev.down setup

default: help

SHELL := /bin/bash

#------------------------------------------------------------------------------
# General operations
#------------------------------------------------------------------------------

#❓ help: @ Displays this message
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(firstword $(MAKEFILE_LIST))| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

#🏃 up.dev: @ Launch the service
up.base:
	@echo ======== Update - wrilya-base ========
	@pulumi up --yes --config dev --cwd ./wrilya-base

#🏃 dev.up.dev: @ Launch the service
dev.up.setup: up.base dev.up.infra
	@echo ======== dev.up.setup Complete ========

dev.up.service: dev.up.env dev.up.app dev.up.ingress
	@echo ======== dev.up.service Complete ========

dev.up.infra:
	@echo ======== Update - wrilya-infra ========
	@pulumi up --yes --config dev --cwd ./wrilya-infra

dev.up.env:
	@echo ======== Update - wrilya-env ========
	@pulumi up --yes --config dev --cwd ./wrilya-env

dev.up.app:
	@echo ======== Update - wrilya-app ========
	@pulumi up --yes --config dev --cwd ./wrilya-app

dev.up.ingress:
	@echo ======== Update - wrilya-ingress ========
	@pulumi up --yes --config dev --cwd ./wrilya-ingress

#🧹 down.dev: @ Delete the whole service
dev.down: dev.down.ingress dev.down.app dev.down.env dev.down.infra
	@echo ======== Release - Complete ========

#🧹 dev.down.infra: @ Delete the whole service
dev.down.infra: 
	@echo ======== Releasing - wrilya-infra ========
	@pulumi down --yes --cwd ./wrilya-infra --config-file Pulumi.dev.yaml

#🧹 dev.down.infra: @ Delete the whole service
dev.down.env: 
	@echo ======== Releasing - wrilya-env ========
	@pulumi down --yes --cwd ./wrilya-env --config-file Pulumi.dev.yaml

dev.down.app: 
	@echo ======== Releasing - wrilya-app ========
	@pulumi down --yes --cwd ./wrilya-app --config-file Pulumi.dev.yaml

dev.down.ingress: 
	@echo ======== Releasing - wrilya-ingress ========
	@pulumi down --yes --cwd ./wrilya-ingress --config-file Pulumi.dev.yaml

