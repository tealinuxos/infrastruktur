# Yum package mirrors repository

> This repo have source code. Builds and deploy docker images for yum package mirrors repository in a containers via yaml formatted config file.

## Quick reference

Where to get help :

- [the Docker Community Forums](https://forums.docker.com/), [the Docker Community Slack](https://blog.docker.com/2016/11/introducing-docker-community-directory-docker-community-slack/), [Stack Overflow](https://stackoverflow.com/search?tab=newest&q=docker), [the Docker Hub](https://hub.docker.com/_/mysql/)

Where to file issues :

- [Report here](https://github.com/tealinuxos/infrastruktur/issues)

Maintained by :

- [DOSCOM Team](https://github.com/tealinuxos)

Supported architectures : ([more info](https://github.com/docker-library/official-images#architectures-other-than-amd64))

- `amd64`

Supported Docker versions :

- [the latest release docker](https://github.com/docker/docker-ce/releases) (down to 1.6 on a best-effort basis)

## Features

- Supports rsync or reposync.
- Can create a large 'all' repo (all pacakges form all repos, smushed together + generated repodata).
- This 'all' repo can be snapshot'ed, to remain frozen in time.
- Likewise, individual repos can be snapshot'd, freezing them in time.
- These 'snaps' are datestamped, and created (optionally) via hardlinks, to be space efficient.
- hardlink (the program) is also used to file-level de-dupe your repos.

A resulting directory structure :

```bash
/mirror/
|__ centos-7-x86_64/
  |__all
  |__all.2017-06-14
  |__os
  |__updates
|__ centos-6_x86_64/
  ...
```

## Build docker images

```bash
    $ docker build -t $NAME_IMAGES:$TAG_IMAGES .
```

## Run images

```bash
    $ docker run --name $NAME_CONTAINER -d $NAME_IMAGES:$TAG_IMAGES
```

## Run images using a volume

```bash
    $ docker run --name $NAME_CONTAINER -v /path/to/storage:/mirror -d $NAME_IMAGES:$TAG_IMAGES
```

or

```bash
    $ docker volume create $REPO_DATA
    $ $REPO_DATA
    $ docker run --name $NAME_CONTAINER -v $REPO_DATA:/mirror -d $NAME_IMAGES:$TAG_IMAGES
```
## Run using a custom configuration file

```bash
    $ docker run --name $NAME_CONTAINER -v /path/to/storage:/mirror -v /path/to/config.yaml:/config.yaml -d $NAME_IMAGES:$TAG_IMAGES
```

## Container viewing logs

```bash
    $ docker logs $NAME_CONTAINER
```

## Container shell access

```bash
    $ docker exec -it $NAME_CONTAINER bash 
```

## Config example :

```yaml
---
:hardlink: true
:hardlink_dir: '/mirror'
:all: true
:all_name: 'all'
:datestamp_all: true
:mirror_base: '/mirror'
mirrors:
  os:
    :dist: 'centos-7-x86_64'
    :type: 'rsync'
    :url: 'rsync://mirrors.kernel.org/centos/7/os/x86_64/'
  extras:
    :dist: 'centos-7-x86_64'
    :type: 'rsync'
    :url: 'rsync://mirrors.kernel.org/centos/7/extras/x86_64/'
    :datestamp: true
    :hardlink_datestamp: true
  plus:
    :dist: 'centos-7-x86_64'
    :type: 'reposync'
    :url: 'rsync://mirrors.kernel.org/centos/7/centosplus/x86_64/'
    :dest: '/some/other/location/'
    :datestamp: true
    :link_datestamp: true
```