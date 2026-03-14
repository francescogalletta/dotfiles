# Agent

## Setup

```bash
cp .env.example .env
# Add your ANTHROPIC_API_KEY to .env
```

## Start

```bash
make dev
```

- API: http://localhost:8000
- Docs: http://localhost:8000/docs

## Test

```bash
curl -X POST http://localhost:8000/chat \
  -H "Content-Type: application/json" \
  -d '{"message": "Say hello in one sentence."}'
```

## Deploy

```bash
echo "fly" > .platform   # or: gcp, railway
make deploy
```
