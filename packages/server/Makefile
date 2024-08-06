#------------------------------------------------------------------------------
# Make setup
#------------------------------------------------------------------------------
include .env

.PHONY: help run clean setup 
.EXPORT_ALL_VARIABLES: 
	DISCORD_CLIENT_ID=${DISCORD_CLIENT_ID}
	DISCORD_CLIENT_SECRET=${DISCORD_CLIENT_SECRET}
	DISCORD_TOKEN=${DISCORD_TOKEN}
	SECRET_KEY_BASE=${SECRET_KEY_BASE}
	GUARDIAN_SECRET=${GUARDIAN_SECRET}
	GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID}
	GOOGLE_CLIENT_SECRET=${GOOGLE_CLIENT_SECRET}
	WRILYA_WEB_SIGNING_SALT=${WRILYA_WEB_SIGNING_SALT}
	ACCOUNT_VAULT_KEY=${ACCOUNT_VAULT_KEY}

default: help

SHELL := /bin/bash

#------------------------------------------------------------------------------
# General operations
#------------------------------------------------------------------------------

#❓ help: @ Displays this message
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(firstword $(MAKEFILE_LIST))| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

# 🏃 run: @ Start up local client
run: setup
	@echo Server starting...
	wait-port 3001
	iex -S mix phx.server
	@echo Server shutting down...

launch: 
	@echo Server starting...
	iex -S mix phx.server
	@echo Server shutting down...

#🧹 clean: @ Delete all temp and downloaded files
clean:
	@echo Server cleaning started...
	mix clean
	@echo Server cleaning complete...

#🏗️  setup: @   Download any deps and run the setup for the environment
setup:
	@echo Server setup started...
	mix deps.get
	mix setup
	@echo Server setup complete...