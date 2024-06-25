#------------------------------------------------------------------------------
# Make setup
#------------------------------------------------------------------------------
.PHONY: help run clean setup env.down env.up phaser build build.docs build.base build.image 

default: help

GKE_CLUSTER_DEV := $(shell cat devops/remote/dev.cluster)
GKE_CLUSTER_PROD := $(shell cat devops/remote/prod.cluster)
GKE_REGION := us-central1

SHELL := /bin/bash
REGISTERY_PATH := us-central1-docker.pkg.dev/rooster-ship-framework/wrilya
ERLANG_VSN := 27.0.0
ELIXIR_VSN := 1.17.1
WRILYA_VSN := 0.1.0
CLIENT_VSN := 0.1.0
RELAYER_VSN := 0.1.0
ifndef SHA
override SHA=0
endif

ifndef BUILD
override BUILD=develop
endif


#------------------------------------------------------------------------------
# General operations
#------------------------------------------------------------------------------

#❓ help: @ Displays this message
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(firstword $(MAKEFILE_LIST))| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

blop:
	@echo $(GKE_CLUSTER)

# 🏃 run: @ Start up local client
run: 
	@echo Client starting...
	pnpm dev
	@echo Client shutting down...

#🧹 clean: @ Delete all temp and downloaded files
clean:
	@echo Client cleaning started...
	$(MAKE) -C packages/contracts clean
	$(MAKE) -C packages/server clean
	@echo Client cleaning complete...

#🏗️  setup: @   Download any deps and run the setup for the environment
setup:
	@echo Setup started...
	$(MAKE) -C packages/server setup
	@echo Setup complete...

login:
	@echo ---------- Remote Services Login started ----------
	@gcloud auth login
	@gcloud auth application-default login
	@echo ---------- Remote Services Login Finished ----------

auth.dev:
	@echo ---------- Authorizing started ----------
	@gcloud container clusters get-credentials $(GKE_CLUSTER_DEV) --region $(GKE_REGION)
	@echo ---------- Authorizing Finished ----------

auth.prod:
	@echo ---------- Authorizing started ----------
	@gcloud container clusters get-credentials $(GKE_CLUSTER_PROD) --region $(GKE_REGION)
	@echo ---------- Authorizing Finished ----------

#------------------------------------------------------------------------------
# Build Operations
#------------------------------------------------------------------------------

#⚙️  env.up:@   Starts up the `docker-compose.yaml` local environment services located in ./devops/local
env.up:
	@echo Spinning Environment Up...
	$(MAKE) -C packages/environment up
	@echo Environment Ready...

#⚙️  env.down:@   Ends the `docker-compose.yaml` local environment services located in ./devops/local
env.down:
	@echo Spinning Environment down...
	$(MAKE) -C packages/environment down
	@echo Spinning Environment Down...

#------------------------------------------------------------------------------
# Build Operations
#------------------------------------------------------------------------------

#👷 build:@ Builds everything
build: build.base build.image
	@echo "Build Complete"

#👷 build.docs:@ Generate the docs
#build.docs:
#	@mix docs -o docs/code --proglang elixir -f html

#👷 build.base:@ Setup the builder project
build.base:
	@docker build -t $(REGISTERY_PATH)/erlang:v$(ERLANG_VSN) -t $(REGISTERY_PATH)/erlang:latest -f ./builder/erlang/Dockerfile ./
	@docker image push $(REGISTERY_PATH)/erlang --all-tags
	@docker build -t $(REGISTERY_PATH)/elixir:v$(ELIXIR_VSN) -t $(REGISTERY_PATH)/elixir:latest -f ./builder/elixir/Dockerfile ./
	@docker image push $(REGISTERY_PATH)/elixir --all-tags
	@docker pull ghcr.io/latticexyz/store-indexer:latest
	@docker tag ghcr.io/latticexyz/store-indexer:latest $(REGISTERY_PATH)/store-indexer:latest
	@docker image push $(REGISTERY_PATH)/store-indexer --all-tags

#👷 build.image:@ Run the actual build
build.service: build.wrilya build.client build.relayer
	@echo ------------------- Build Complete ----------------

build.wrilya:
	@echo ------------------- Wrilya ----------------
	@cd packages/server && mix deps.get
	@docker build --build-arg="RELEASE_TYPE=wrilya" -t $(REGISTERY_PATH)/wrilya:$(BUILD) -t $(REGISTERY_PATH)/wrilya:sha_$(SHA) -t $(REGISTERY_PATH)/wrilya:v$(WRILYA_VSN) -t $(REGISTERY_PATH)/wrilya:latest -f ./builder/server/Dockerfile ./packages/server
	@docker image push $(REGISTERY_PATH)/wrilya --all-tags

build.contracts:
	@echo ------------------- Wrilya ----------------
	$(MAKE) -C packages/contracts build

build.client: build.contracts
	@echo ------------------- Client ----------------
	@cd packages/client && pnpm run build
	@docker build -t $(REGISTERY_PATH)/client:$(BUILD) -t $(REGISTERY_PATH)/client:sha_$(SHA) -t $(REGISTERY_PATH)/client:v$(CLIENT_VSN) -t $(REGISTERY_PATH)/client:latest -f ./builder/client/Dockerfile ./packages/client
	@docker image push $(REGISTERY_PATH)/client --all-tags

build.relayer:
	@echo ------------------- Relayer ----------------
	@rm -rf packages/relayer/dist
	@cd packages/relayer && pnpm --filter=relayer deploy dist --prod
	@docker build -t $(REGISTERY_PATH)/relayer:$(BUILD) -t $(REGISTERY_PATH)/relayer:sha_$(SHA) -t $(REGISTERY_PATH)/relayer:v$(RELAYER_VSN) -t $(REGISTERY_PATH)/relayer:latest -f ./builder/relayer/Dockerfile ./packages/relayer
	@docker image push $(REGISTERY_PATH)/relayer --all-tags