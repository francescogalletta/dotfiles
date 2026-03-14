.PHONY: dev build test shell logs stop run

# Run the CLI (pass ARGS="--help" etc.)
run:
	docker compose run --rm app $(ARGS)

# Hot-reload dev mode (re-runs on file change using watchdog)
dev:
	docker compose run --rm app watchmedo auto-restart --patterns="*.py" --recursive -- python -m app.main $(ARGS)

build:
	docker compose build

test:
	docker compose run --rm app pytest

shell:
	docker compose run --rm --entrypoint /bin/bash app

logs:
	docker compose logs -f

stop:
	docker compose down
