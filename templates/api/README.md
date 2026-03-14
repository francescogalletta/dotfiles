# API

## Start

```bash
make dev
```

- API: http://localhost:8000
- Docs: http://localhost:8000/docs

## Common tasks

```bash
make test    # run tests
make shell   # drop into container shell
make logs    # tail logs
make stop    # stop all services
```

## Deploy

```bash
echo "fly" > .platform   # or: gcp, railway
make deploy
```
