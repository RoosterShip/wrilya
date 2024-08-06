#------------------------------------------------------------------------------
# Make setup
#------------------------------------------------------------------------------
.PHONY: help run clean setup down up 

default: help

SHELL := /bin/bash

#------------------------------------------------------------------------------
# General operations
#------------------------------------------------------------------------------

#❓ help: @ Displays this message
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(firstword $(MAKEFILE_LIST))| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

#⚙️  env.up:@   Starts up the docker environment services
up:
	@echo Spinning environment Up...
	@docker compose -f docker-compose.yaml up --build
	@echo Spinning environment Down...

#⚙️  env.down:@   Shutdowns the docker environment services
down:
	@echo Spinning environment down...
	@docker compose -f docker-compose.yaml --profile healthy down
	@echo Spinning environment down compete...

#⚙️  env.attach:@   Streams the logs coming from the docker environment
attach:
	@echo Spinning environment down...
	@docker compose -f docker-compose.yaml --profile healthy down
	@echo Spinning environment down compete...
