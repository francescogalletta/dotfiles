# Data Project

## Start

```bash
make dev
```

- Jupyter Lab: http://localhost:8888
- Streamlit app: http://localhost:8501

## Common tasks

```bash
make shell   # drop into container shell
make logs    # tail logs
make stop    # stop all services
```

## Structure

```
app/         Streamlit app
notebooks/   Jupyter notebooks
```

## Database

Uncomment the `db` service in `docker-compose.yml` and copy `.env.example` to `.env`.
