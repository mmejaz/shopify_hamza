# Shopify theme development environment
# Runs the Shopify CLI (theme dev / pull / push / check) in a reproducible container.
FROM node:22-bookworm-slim

# Shopify CLI shells out to git and needs CA certs for the storefront connection.
RUN apt-get update \
  && apt-get install -y --no-install-recommends git ca-certificates curl \
  && rm -rf /var/lib/apt/lists/*

# Install the Shopify CLI globally.
RUN npm install -g @shopify/cli@latest

# The container has no GUI/browser. The CLI's device-login step tries to open a
# browser via `xdg-open`, which doesn't exist here and crashes the process.
# Provide a no-op `xdg-open` so login just prints the URL (we open it on the host).
RUN printf '#!/bin/sh\nexit 0\n' > /usr/local/bin/xdg-open && chmod +x /usr/local/bin/xdg-open

# Default target store, baked in so the CLI works even for a bare `docker run`
# or the Docker Desktop "Run" button (no .env). docker-compose still overrides
# via env_file for anyone who needs a different store.
ENV SHOPIFY_FLAG_STORE=onteriorenterprises-com

# Theme files are bind-mounted here from ./theme by docker-compose.
WORKDIR /theme

# 9292 = local preview, 9293 = hot-reload websocket.
EXPOSE 9292 9293

# Default: start the live-reloading dev server. Store is passed explicitly here
# AND via SHOPIFY_FLAG_STORE above, so the default command can never hit
# "A store is required" regardless of how the container is launched.
CMD ["shopify", "theme", "dev", "--store", "onteriorenterprises-com", "--host", "0.0.0.0"]
