include .env

# -------------------------------------------------------------------------------------------------
# Constants
# -------------------------------------------------------------------------------------------------
CURRENT_DATE:=$(shell date +"%Y-%m-%d-T%H%M%S")
MAKEFILE_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# -------------------------------------------------------------------------------------------------
# Environment variables
# -------------------------------------------------------------------------------------------------
TOOLS_DOCKER_IMAGE_NAME:=$(DOCKERHUB_USERNAME)/iac-tools:latest
TOOLS_DOCKER_CONTAINER_NAME:=$(DOCKERHUB_USERNAME)_iac-tools

# -------------------------------------------------------------------------------------------------
# Functions
# -------------------------------------------------------------------------------------------------
default: help

.PHONY: help
help: ## List makefile targets
		@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: vps-init
vps-init:
	@docker run --rm --interactive --tty \
		--env VPS_USER=$(VPS_USER) \
		--env VPS_PASSWORD=$(VPS_PASSWORD) \
		--env VPS_HOST=$(VPS_HOST) \
		--env VPS_PORT=$(VPS_PORT) \
		--env VPS_PUBLIC_SSH_KEY=$(VPS_PUBLIC_SSH_KEY) \
		--env VPS_SECURE_SSH_PORT=$(VPS_SECURE_SSH_PORT) \
		--env IAC_USER=$(IAC_USER) \
		--volume $(MAKEFILE_DIR)/tools/vps:/app \
		--workdir /app \
		--name $(TOOLS_DOCKER_CONTAINER_NAME) \
		$(TOOLS_DOCKER_IMAGE_NAME) \
		bash ./init.sh
