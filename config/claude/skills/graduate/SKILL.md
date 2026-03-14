---
name: graduate
description: Deploy a prototype to a live URL. Use when the user says "deploy this", "let's go live", "graduate this", or "/graduate". Guides platform selection, generates deploy configs, sets up CI/CD, and does the first deployment.
user-invocable: true
---

# /graduate

Takes a local prototype to a live deployment. Docker is the abstraction — the image that runs locally goes to production unchanged.

## Step 1 — Assess

Read the project to understand the stack:
- What's in `docker-compose.yml`?
- Does it have a database? Background workers? File storage?
- Is there a `deploy/` directory already?

## Step 2 — Platform selection

Ask the user which platform if not obvious. Present this trade-off table:

| Platform | Pros | Cons | Best when |
|----------|------|------|-----------|
| **Fly.io** | Simplest DX, global edge, free tier | Less Google-ecosystem integration | Demos, personal tools, early prototypes |
| **GCP Cloud Run** | Scales to zero, Google ecosystem, enterprise-grade | More setup, gcloud CLI required | Production workloads, org projects |
| **Railway** | Fastest from zero to live, good DX | Less control, opinionated | Quickest possible demo |
| **Vercel** (frontend only) | Best Next.js DX, CDN-native | Frontend only | Next.js frontends |

Default recommendation: **Fly.io** for prototypes, **GCP Cloud Run** for production.

Also ask about optional services:
- Database? (Neon, Supabase, or Cloud SQL)
- Async task queue?
- File/object storage?

## Step 3 — Generate deploy configs

Create a `deploy/` directory with the appropriate provider subdirectory.

### Fly.io

```bash
# If fly.toml doesn't exist yet:
flyctl launch --no-deploy --copy-config
```

Then write `deploy/fly/github-actions.yml`:

```yaml
name: Deploy to Fly.io

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: superfly/flyctl-actions/setup-flyctl@master
      - run: flyctl deploy --remote-only
        env:
          FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}
```

### GCP Cloud Run

Write `deploy/gcp/cloudrun.yaml` and `deploy/gcp/github-actions.yml`:

```yaml
name: Deploy to Cloud Run

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      id-token: write
    steps:
      - uses: actions/checkout@v4
      - uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: ${{ secrets.GCP_WORKLOAD_IDENTITY_PROVIDER }}
          service_account: ${{ secrets.GCP_SERVICE_ACCOUNT }}
      - uses: google-github-actions/deploy-cloudrun@v2
        with:
          service: REPLACE_APP_NAME
          region: europe-west2
          source: .
```

### .platform file

Write the chosen platform to `.platform` (gitignored):

```bash
echo "fly" > .platform  # or: gcp, railway
```

### Makefile deploy target (if not present)

Add to the project's Makefile:

```makefile
deploy:
	@PLATFORM=$${PLATFORM:-$$(cat .platform 2>/dev/null || echo fly)}; \
	  $(MAKE) deploy-$$PLATFORM

deploy-fly:
	flyctl deploy

deploy-gcp:
	gcloud run deploy --source .
```

## Step 4 — Platform setup commands

Run setup commands for the chosen platform:

### Fly.io
```bash
flyctl auth login       # if not already
flyctl launch           # interactive: sets app name, region, etc.
flyctl secrets set ANTHROPIC_API_KEY=... DATABASE_URL=...  # from .env
```

### GCP
```bash
gcloud auth login
gcloud projects create <project-id>
gcloud run deploy --region=europe-west2 --source .
```

**Check with the user before running any commands that create billable resources.**

## Step 5 — First deployment

Run the deploy and wait for the live URL. Print:

```
Deployed to: https://<app>.<provider>.app

Next:
  make deploy          — deploy future changes
  <GitHub Actions>     — set up secrets for CI/CD (see deploy/<provider>/github-actions.yml)
```

## Step 6 — GitHub Actions (optional)

Ask: "Want me to set up GitHub Actions for automatic deploys on push to main?"

If yes:
1. Copy the relevant `github-actions.yml` to `.github/workflows/deploy.yml`
2. List the secrets that need to be added to the GitHub repo
3. Print instructions for adding them
