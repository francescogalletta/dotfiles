.PHONY: dev build test shell shell-frontend logs stop deploy

dev:
	docker compose up --watch

build:
	docker compose build

test:
	docker compose run --rm backend pytest

shell:
	docker compose run --rm backend /bin/bash

shell-frontend:
	docker compose run --rm frontend /bin/sh

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
