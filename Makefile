# Convenience wrapper around the Dockerised Shopify CLI.
# Usage: `make dev`, `make pull`, `make push`, `make check`, `make shell`, `make login`.

COMPOSE = docker compose
RUN     = $(COMPOSE) run --rm --service-ports theme

.PHONY: build dev login pull push check shell down clean

build:            ## Build the CLI image
	$(COMPOSE) build

dev:              ## Start live-reload dev server -> http://localhost:9292
	$(COMPOSE) up

login:            ## Authenticate the Shopify CLI (device-code flow)
	$(RUN) shopify auth logout || true
	$(RUN) shopify theme list --store $${SHOPIFY_STORE:-onteriorenterprises-com}

pull:             ## Pull the live theme into ./theme
	$(RUN) shopify theme pull --store onteriorenterprises-com

push:             ## Push ./theme to an UNPUBLISHED theme (safe)
	$(RUN) shopify theme push --unpublished --store onteriorenterprises-com

check:            ## Run Theme Check (linter)
	$(RUN) shopify theme check

shell:            ## Open a shell in the container
	$(RUN) bash

down:             ## Stop containers
	$(COMPOSE) down

clean:            ## Stop and remove the persisted CLI login volumes
	$(COMPOSE) down -v
