# Shopify theme development environment
# Runs the Shopify CLI (theme dev / pull / push / check) in a reproducible container.
FROM node:22-bookworm-slim

# Shopify CLI shells out to git and needs CA certs for the storefront connection.
RUN apt-get update \
  && apt-get install -y --no-install-recommends git ca-certificates curl \
  && rm -rf /var/lib/apt/lists/*

# Install the Shopify CLI globally.
RUN npm install -g @shopify/cli@latest

# Theme files are bind-mounted here from ./theme by docker-compose.
WORKDIR /theme

# 9292 = local preview, 9293 = hot-reload websocket.
EXPOSE 9292 9293

# Default: start the live-reloading dev server. Overridable via docker compose.
CMD ["shopify", "theme", "dev", "--host", "0.0.0.0"]
