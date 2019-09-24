.DEFAULT_GOAL := help
AWS_ACCESS_KEY_ID ?= "AKIAXUXIHLSDIEIYVT4Z"
AWS_SECRET_ACCESS_KEY ?= "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" 
AWS_DEFAULT_REGION ?="us-west-2" 

## format
version:
	docker run  -v $(PWD):/app -w /app \
		--entrypoint "sh" \
		-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		-e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) --rm hashicorp/terraform -c "terraform version"

## format
format:
	docker run  -v $(PWD):/app -w /app \
		--entrypoint "sh" \
		-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		-e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) --rm hashicorp/terraform -c "terraform fmt -recursive"

## validate
validate:
	docker run -v $(PWD):/app -w /app \
		--entrypoint "sh" \
		-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		-e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) --rm hashicorp/terraform -c "terraform init"
	docker run  -v $(PWD):/app -w /app \
		-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		-e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) --rm hashicorp/terraform "validate"

## Create infra takes variable aws_private_key and tag-environment
apply:
	docker run -v $(PWD):/app -w /app \
		--entrypoint "sh" \
		-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		-e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) --rm hashicorp/terraform -c "terraform init"
	docker run  -v $(PWD):/app -w /app \
		-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		-e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) --rm hashicorp/terraform "validate"
	docker run  -v $(PWD):/app -w /app \
		--entrypoint "sh" \
		-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		-e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) --rm hashicorp/terraform -c "terraform apply -auto-approve"

## Destroy infra, must confirm with yes
destroy:
	docker run  -v $(PWD):/app -w /app \
		--entrypoint "sh" \
		-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		-e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) --rm hashicorp/terraform -c "terraform destroy -auto-approve"

## Show output of apply 
output:
	docker run  -v $(PWD):/app -w /app \
		--entrypoint "sh" \
		-e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID) \
		-e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY) \
		-e AWS_DEFAULT_REGION=$(AWS_DEFAULT_REGION) --rm hashicorp/terraform -c "terraform output -json" \
		| jq '.masters.value.private_ip[0]'

# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)


TARGET_MAX_CHAR_NUM=20
## Show this help
help:
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)



.PHONY: apply destroy output help format version
