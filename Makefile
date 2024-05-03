#------------------------------------------------------------------------------
# Make setup
#------------------------------------------------------------------------------
.PHONY: help run clean setup env.down env.up phaser 

default: help

SHELL := /bin/bash

#------------------------------------------------------------------------------
# General operations
#------------------------------------------------------------------------------

#❓ help: @ Displays this message
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(firstword $(MAKEFILE_LIST))| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

# 🏃 run: @ Start up local client
run: phaser
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

phaser:
	@echo Launching Phaser Desktop...
	@cd packages/client && PhaserEditor-desktop 1> /dev/null 2> /dev/null &
	
