# Web App

## Start

```bash
make dev
```

- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs

## Common tasks

```bash
make test            # run backend tests
make shell           # backend container shell
make shell-frontend  # frontend container shell
make logs            # tail logs
make stop            # stop all services
```

## Deploy

```bash
echo "fly" > .platform   # or: gcp, railway
make deploy
```

Frontend can also be deployed to Vercel independently (`vercel --cwd frontend`).
