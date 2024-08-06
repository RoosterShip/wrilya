#------------------------------------------------------------------------------
# Make setup
#------------------------------------------------------------------------------
.PHONY: help build run test

default: help

SHELL := /bin/bash

#------------------------------------------------------------------------------
# General operations
#------------------------------------------------------------------------------

#❓ help: @ Displays this message
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(firstword $(MAKEFILE_LIST))| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

#👷 build:@ Builds Contracts
build.prod: 
	@echo Contract building started...
	@pnpm build.prod
	@echo Contract building complete

build.test: 
	@echo Contract building started...
	@pnpm build.test
	@echo Contract building complete

#🏃 run: @ Start up local client
run:
	@echo Contracts starting...
	@pnpm start
	@echo Contracts shutdown

#🧪 test:@ Run the unit tests
test:
	@echo testing started...
	@pnpm test
	@echo testing complete.