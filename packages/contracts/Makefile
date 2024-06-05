#------------------------------------------------------------------------------
# Make setup
#------------------------------------------------------------------------------
.PHONY: help build clean insepct test deploy.governance

default: help

SHELL := /bin/bash

include .env

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

deploy.test.vote:
	@forge create --legacy --optimize --optimizer-runs 5000 --via-ir --rpc-url $(GOVERNANCE_TEST_CHAIN_RPC) --chain-id $(GOVERNANCE_TEST_CHAIN_ID) --private-key $(GOVERNANCE_TEST_PRIVATE_KEY) src/governance/vote.sol:WrilyaVoteToken

deploy.test.governor:
	@forge create --legacy --optimize --optimizer-runs 4999 --via-ir  --rpc-url $(GOVERNANCE_TEST_CHAIN_RPC) --chain-id $(GOVERNANCE_TEST_CHAIN_ID) --private-key $(GOVERNANCE_TEST_PRIVATE_KEY) src/governance/governor.sol:WrilyaGovernor  --constructor-args $(GOVERNANCE_TEST_VOTE_ADDRESS)

deploy.live.vote:
	@forge create --legacy --optimize --optimizer-runs 5000 --via-ir --rpc-url $(GOVERNANCE_LIVE_CHAIN_RPC) --chain-id $(GOVERNANCE_LIVE_CHAIN_ID) --private-key $(GOVERNANCE_LIVE_PRIVATE_KEY) src/governance/vote.sol:WrilyaVoteToken

deploy.live.governor:
	@forge create --legacy --optimize --optimizer-runs 5000 --via-ir --rpc-url $(GOVERNANCE_LIVE_CHAIN_RPC) --chain-id $(GOVERNANCE_LIVE_CHAIN_ID) --private-key $(GOVERNANCE_LIVE_PRIVATE_KEY) src/governance/governor.sol:WrilyaGovernor  --constructor-args $(GOVERNANCE_LIVE_VOTE_ADDRESS) 

