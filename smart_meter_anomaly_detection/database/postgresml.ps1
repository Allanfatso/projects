docker run -d --name postgresml \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=password \
  ghcr.io/postgresml/postgresml:latest
