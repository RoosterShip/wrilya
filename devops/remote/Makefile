#------------------------------------------------------------------------------
# Make setup
#------------------------------------------------------------------------------
.PHONY: help up.dev down.dev setup

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
	@echo ======== Update - Complete ========

#🏃 up.dev: @ Launch the service
up.dev: up.base up.dev.infra up.dev.env up.dev.app up.dev.ingress
	@echo ======== Dev Ready ========

up.dev.infra:
	@echo ======== Update - wrilya-infra ========
	@pulumi up --yes --config dev --cwd ./wrilya-infra
	@echo ======== Update - Complete ========

up.dev.env:
	@echo ======== Update - wrilya-env ========
	@pulumi up --yes --config dev --cwd ./wrilya-env
	@echo ======== Update - Complete ========

up.dev.app:
	@echo ======== Update - wrilya-app ========
	@pulumi up --yes --config dev --cwd ./wrilya-app
	@echo ======== Update - Complete ========

up.dev.ingress:
	@echo ======== Update - wrilya-ingress ========
	@pulumi up --yes --config dev --cwd ./wrilya-ingress
	@echo ======== Update - Complete ========

#🧹 down.dev: @ Delete the whole service
down.dev: down.dev.app down.dev.env down.dev.infra
	@echo ======== Releasing - Complete ========

#🧹 down.dev.infra: @ Delete the whole service
down.dev.infra: 
	@echo ======== Releasing - wrilya-infra ========
	@pulumi down --yes --cwd ./wrilya-infra --config-file Pulumi.dev.yaml
	@echo ======== Releasing - Complete ========

#🧹 down.dev.infra: @ Delete the whole service
down.dev.env: 
	@echo ======== Releasing - wrilya-env ========
	@pulumi down --yes --cwd ./wrilya-env --config-file Pulumi.dev.yaml
	@echo ======== Releasing - Complete ========

down.dev.app: 
	@echo ======== Releasing - wrilya-app ========
	@pulumi down --yes --cwd ./wrilya-app --config-file Pulumi.dev.yaml
	@echo ======== Releasing - Complete ========

#🏗️  setup: @   Download any deps and run the setup for the environment
setup:
	@echo Setup started...
	@echo Setup complete...
