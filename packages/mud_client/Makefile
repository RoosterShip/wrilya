#------------------------------------------------------------------------------
# Make setup
#------------------------------------------------------------------------------
.PHONY: help build clean insepct test

default: help

SHELL := /bin/bash

#------------------------------------------------------------------------------
# General operations
#------------------------------------------------------------------------------

#❓ help: @ Displays this message
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(firstword $(MAKEFILE_LIST))| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

#🏃 run: @ Start up local client
run:
	@echo Contracts starting...
	@pnpm dev
	@echo Contracts shutdown

#🧪 test:@ Run the unit tests
test:
	@echo testing started...
	@pnpm test
	@echo testing complete.