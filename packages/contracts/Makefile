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

#👷 build:@ Builds Contracts
build: 
	@echo Contract building started...
	@pnpm build
	@echo Contract building complete

#🏃 run: @ Start up local client
run:
	@echo Contracts starting...
	@pnpm dev
	@echo Contracts shutdown

#🧹 clean: @ Delete all temp and downloaded files
clean:
	@echo Contract cleaning started...
	@rm -rf broadcast
	@rm -rf cache
	@rm -rf deploys
	@rm -rf out
	@echo Contract cleaning complete.

#🔍 inspect:@ run the code linter and security tools
inspect:
	@echo inspection started...
	@pnpm lint
	@echo inspection complete.

#🧪 test:@ Run the unit tests
test:
	@echo testing started...
	@pnpm test
	@echo testing complete.