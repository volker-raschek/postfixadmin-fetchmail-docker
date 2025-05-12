# PostfixAdmin's fetchmail

[![Docker Pulls](https://img.shields.io/docker/pulls/volkerraschek/postfixadmin-fetchmail)](https://hub.docker.com/r/volkerraschek/postfixadmin-fetchmail)

This project contains all sources to build the container image
`git.cryptic.systems/volker.raschek/postfixadmin-fetchmail`. The primary goal of the image is to fetch mails from
external servers and forward them to on local running mail server.

The configuration file will be automatically generated based on information from a supported database backend of
[postfixadmin](https://github.com/postfixadmin/postfixadmin). The information are stored in the table `fetchmail` of the
database scheme of PostfixAdmin.

## Usage

Possible database types are `my` for MySQL and `Pg` for postgres. Make sure that the database and the SMTP server are
accessible. Otherwise, adjust the enclosed docker-compose or docker command accordingly. Alternatively you can use
docker-compose in addition to the docker commands.

### PostgreSQL

```bash
$ docker run \
  --rm \
  --env DATABASE_TYPE: Pg \
  --env DATABASE_HOST: postgres \
  --env DATABASE_PORT: 5432 \
  --env DATABASE_NAME: postgres \
  --env DATABASE_USER: fetchmail \
  --env DATABASE_PASSWORD: MySecretPassword \
  --network host \
  volkerraschek/fetchmail:latest
```

### MySQL

```bash
$ docker run \
  --rm \
  --env DATABASE_TYPE: my \
  --env DATABASE_HOST: root \
  --env DATABASE_PORT: 3306 \
  --env DATABASE_NAME: mysql \
  --env DATABASE_USER: fetchmail \
  --env DATABASE_PASSWORD: MySecretPassword \
  --network host \
  volkerraschek/fetchmail:latest
```

### docker-compose

The repository contains a default `docker-compose.yml` file, which can be used to start the container. To set the
environment variables you need a `.env` file. The `.dev_env` from this repository can be used for this. This must be
located exclusively in the same directory as the `docker-compose.yml` file and must be renamed as `.env`.

```yml
version: "3"
services:
  fetchmail:
    image: volkerraschek/fetchmail:latest
    environment:
    - DATABASE_TYPE=${DATABASE_TYPE}
    - DATABASE_HOST=${DATABASE_HOST}
    - DATABASE_HOST=${DATABASE_PORT}
    - DATABASE_NAME=${DATABASE_NAME}
    - DATABASE_USER=${DATABASE_USER}
    - DATABASE_PASSWORD=${DATABASE_PASSWORD}
    network_mode: host
```

## Environment variables

### DATABASE_TYPE

Currently will be only postgres, mysql and mariadb supported. About the environment variable `DATABASE_TYPE` can the
backend type defined. The value is required.

| database type | value |
| ------------- | ----- |
| mysql/mariadb | `my`  |
| postgres      | `Pg`  |

### DATABASE_USER

The environment variable `DATABASE_USER` is undefined and required. The value contains the database user which one
fetchmail use to login.

### DATABASE_PASSWORD

The environment variable `DATABASE_PASSWORD` is undefined and required. The value contains the password of the database
user which one fetchmail use to login.

### DATABASE_HOST

The environment variable `DATABASE_HOST` is undefined and required. The value contains the DNS name or IP address of the
host, where the database is hosted.

### DATABASE_PORT

The environment variable `DATABASE_PORT` is undefined and required. The value contains the port of the host, where the
database is listen on.

### DATABASE_NAME

The environment variable `DATABASE_NAME` is undefined and required. The value contains the name of the database against
which should be logged in.
