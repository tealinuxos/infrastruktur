# Compose PHPDos

> Builds, deploy, and run multi-container applications with docker for PHP Apps.

## Quick reference

Where to get help :

- [the Docker Community Forums](https://forums.docker.com/), [the Docker Community Slack](https://blog.docker.com/2016/11/introducing-docker-community-directory-docker-community-slack/), [Stack Overflow](https://stackoverflow.com/search?tab=newest&q=docker), [the Docker Hub](https://hub.docker.com/_/mysql/)

Where to file issues :

- [Report here](https://github.com/tealinuxos/infrastruktur/issues)

Maintained by:

- [DOSCOM Team](https://github.com/tealinuxos)

Supported architectures: ([more info](https://github.com/docker-library/official-images#architectures-other-than-amd64))

- `amd64`

Supported Docker versions:

- [the latest release docker](https://github.com/docker/docker-ce/releases) (down to 1.6 on a best-effort basis)

## Container

A resulting docker service :

- WebApps
- WebServer
- DataBase
- Dashboard DB (PHPMyAdmin)

## Run Docker Compose

Clone this repository... Execute docker compose use this command to create & start multi-container...

```bash
    $ docker-compose up
```

## Docker Compose view logs

```bash
    $ docker-compose logs
```

or

```bash
    $ docker-compose logs $SERVICE
```

## Docker Compose execute shell

```bash
    $ docker-compose exec $SERVICE php --version
```

## Deploy laravel example

1. Grab the latest laravel

```bash
    $ composer create-project --prefer-dist laravel/laravel $NAME_PROJECT
```

2. Install dependencies via docker

```bash
    $ docker run --rm -v $(pwd)/$NAME_PROJECT:/app composer/composer install
```

3. Create or clone `docker-compose.yml`, `doscom-webapps.dockerfile`, `doscom-webserver.dockerfile`, & `vhost.conf`

4. Start docker compose

```bash
    $ docker-compose -f /path/to/docker-compose.yml up
```

5. Prepare the Laravel application

```bash
    # Application key
    $ docker-compose exec $SERVICE php artisan key:generate
    # Optimize
    $ docker-compose exec $SERVICE php artisan optimize
    # Migrate seed DB
    $ docker-compose exec $SERVICE php artisan migrate --seed
    # Create controller
    $ docker-compose exec $SERVICE php artisan make:controller MyController
```