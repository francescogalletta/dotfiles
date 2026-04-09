.PHONY: dev build test shell logs stop deploy

dev:
	docker compose up --watch

build:
	docker compose build

test:
	docker compose run --rm jupyter sh -c "uv sync --frozen && pytest"

shell:
	docker compose run --rm jupyter /bin/bash

logs:
	docker compose logs -f

stop:
	docker compose down

deploy:
	@PLATFORM=$${PLATFORM:-$$(cat .platform 2>/dev/null || echo fly)}; \
	  $(MAKE) deploy-$$PLATFORM

deploy-fly:
	flyctl deploy

deploy-gcp:
	gcloud run deploy --source .
