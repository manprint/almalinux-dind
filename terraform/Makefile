.PHONY: help

TITLE_MAKEFILE=Terraform Almalinux Manage

SHELL=/bin/bash
.SHELLFLAGS += -eo pipefail
.ONESHELL:

export CURRENT_DIR := $(shell pwd)
export RED := $(shell tput setaf 1)
export RESET := $(shell tput sgr0)
export DATE_NOW := $(shell date)

.DEFAULT := help

help:
	@printf "\n$(RED)$(TITLE_MAKEFILE)$(RESET)\n"
	@awk 'BEGIN {FS = ":.*##"; printf "\n\033[1mUsage:\n  make \033[36m<target>\033[0m\n"} \
	/^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ \
	{ printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@echo

##@ Terraform Managements

init: ## Terraform init
	@terraform init

plan: ## Terraform plan
	@terraform plan -out dind_alma_plan.zip

apply: ## Terraform apply
	@terraform apply --auto-approve "dind_alma_plan.zip" 

destroy: ## Terraform destroy
	@terraform destroy --auto-approve

connect: ## Connect to container
	@docker exec -it --user=alma dind_almalinux bash