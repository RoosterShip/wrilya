#------------------------------------------------------------------------------
# Make setup
#------------------------------------------------------------------------------
.PHONY: help run clean setup env.down env.up phaser build build.docs build.base build.image 

default: help

SHELL := /bin/bash
REGISTERY_PATH := us-docker.pkg.dev/rooster-ship-framework/wrilya
ERLANG_VSN := 27.0.0
ELIXIR_VSN := 1.17.1
WRILYA_VSN := 0.1.0

#------------------------------------------------------------------------------
# General operations
#------------------------------------------------------------------------------

#❓ help: @ Displays this message
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(firstword $(MAKEFILE_LIST))| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

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

#👷 build.image:@ Run the actual build
build.image:
	@docker build --build-arg="RELEASE_TYPE=wrilya" -t $(REGISTERY_PATH)/wrilya:v$(WRILYA_VSN) -t $(REGISTERY_PATH)/wrilya:latest -f ./builder/server/Dockerfile ./packages/server
	@docker image push $(REGISTERY_PATH)/wrilya --all-tags