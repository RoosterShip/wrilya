#------------------------------------------------------------------------------
# Make setup
#------------------------------------------------------------------------------
.PHONY: help run clean setup 

default: help

SHELL := /bin/bash

include .env

#------------------------------------------------------------------------------
# General operations
#------------------------------------------------------------------------------

#❓ help: @ Displays this message
help:
	@grep -E '[a-zA-Z\.\-]+:.*?@ .*$$' $(firstword $(MAKEFILE_LIST))| tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'

# 🏃 run: @ Start up local client
run: setup
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