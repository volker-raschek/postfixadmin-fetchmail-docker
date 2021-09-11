# fetchmail-docker

[![Build Status](https://drone.cryptic.systems/api/badges/volker.raschek/fetchmail-docker/status.svg)](https://drone.cryptic.systems/volker.raschek/fetchmail-docker)
[![Docker Pulls](https://img.shields.io/docker/pulls/volkerraschek/fetchmail)](https://hub.docker.com/r/volkerraschek/fetchmail)

This project contains all sources to build the container image
`docker.io/volkerraschek/fetchmail`. The primary goal of the image is to fetch
mails from external servers and forward them to on local running mail server.

The configuration file will be automatically generated based on information from
a database. As table the fetchmail table from the schema of
[postfixadmin](https://github.com/postfixadmin/postfixadmin) is expected.

## Usage

Possible database types are `my` for MySQL and `Pg` for postgres. Make sure that
the database and the SMTP server are accessible. Otherwise, adjust the enclosed
docker-compose or docker command accordingly. Alternatively you can use
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

The repository contains a default `docker-compose.yml` file, which can be used
to start the container. To set the environment variables you need a `.env` file.
The `.dev_env` from this repository can be used for this. This must be located
exclusively in the same directory as the `docker-compose.yml` file and must be
renamed as `.env`.

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

## Build container image manually

To build the images manually check out the repository on
[github](https://github.com/volker-raschek/fetchmail-docker) with git and use
the make command to build the container image.

```bash
make container-image/build
```
