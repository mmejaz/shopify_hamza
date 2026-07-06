# Onterior Enterprises — Shopify Theme (local dev)

Dockerised local development for the **Onterior Enterprises** Shopify theme.
You edit the theme in `./theme/` on your machine; the Shopify CLI (running in
Docker) serves a **live-reloading preview at http://localhost:9292** that syncs
with the store.

> Shopify renders Liquid on its servers, so there is no fully-offline preview.
> `theme dev` connects to the store to render, but **all editing is local** and
> nothing is published until you explicitly push/publish.

## Layout

```
shopify/
├── theme/              # the Shopify theme (sections, templates, assets, …)
├── Dockerfile          # Node + Shopify CLI image
├── docker-compose.yml  # mounts ./theme, exposes 9292/9293, runs `theme dev`
├── .env                # SHOPIFY_STORE + storefront password (git-ignored)
├── Makefile            # shortcuts: make dev / pull / push / check / shell
└── README.md
```

## One-time setup

1. **Configure `.env`** (already created from `.env.example`):
   ```
   SHOPIFY_STORE=onteriorenterprises-com
   SHOPIFY_STORE_PASSWORD=<storefront password>
   ```
   Get the storefront password from **Shopify admin → Online Store →
   Preferences → Password protection**. (Leave empty once the store is public.)

2. **Build the image:**
   ```bash
   make build      # or: docker compose build
   ```

## Daily use

```bash
make dev          # start the dev server -> http://localhost:9292
```

- **First run** prints a device-code login link + code. Open the link, sign in,
  confirm the code. Your login is saved in a Docker volume, so you only do this
  once.
- Edit files in `./theme/` → the browser at `localhost:9292` hot-reloads.
- `Ctrl-C` to stop (or `make down`).

## Other commands

| Command | What it does |
|---|---|
| `make pull`  | Pull the live theme into `./theme` (overwrites local) |
| `make push`  | Push `./theme` to a new **unpublished** theme (safe) |
| `make check` | Run Theme Check (Liquid linter) |
| `make shell` | Open a shell inside the container |
| `make clean` | Reset the saved CLI login |

## What's in this theme

Base **Trade** theme plus custom Onterior work:

- **About page** — `templates/page.about.json` composed of custom sections:
  `about-hero`, `about-story`, `about-stats`, `about-process`, `about-quote`,
  `about-perks` (all editable in the Theme Editor).
- **Shared brand assets** — `assets/onterior-base.css` (colour tokens, fonts,
  animations), `assets/onterior.js` (scroll-reveal + counters),
  `snippets/onterior-icon.liquid`.
- Brand fonts (Playfair Display / Jost / Great Vibes) wired into
  `layout/theme.liquid`.
# shopify_hamza
