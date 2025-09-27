# Eventify (Rails API)

## Getting started

### Install dependencies

```shell
asdf Install
bundle install
```

### Configure environment

```shell
cp .env.example .env
```

### Check database connection

```shell
rails db:version
rails db:prepare
```

### Run database migration

```shell
rails db:reset # erases DB
rails db:migrate # runs DB migrations
rails db:seed # adds record into DB tables
```

### Run server

```shell
rails s -p 7000
```
## Swagger UI (/api-docs)

The API documentation is available at the `/api-docs` route.

In `swagger.yaml` the `servers:` block is not defined — it is generated dynamically.

- In **development**, Swagger uses the local server address (http://localhost:PORT).
- In **production**, it uses the actual domain where the UI is served.
- If needed, you can explicitly set the base URL via the `SWAGGER_SERVER_URL` environment variable.

Example:
```bash
export SWAGGER_SERVER_URL=https://api.eventify.com

### Run all tests

```shell
rspec
```