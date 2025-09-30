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

### Run all tests

```shell
rspec
```