# Apt(Advanced Packaging Tools) mirror repository & web-server

> This repo have source code. Builds and deploy docker images for apt mirrors repository with web-server in a containers.

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

- Supports 32-bit and 64-bit
- Support debian mirror repository
- Include webserver

A resulting directory structure :

```bash
/mirror/
|__ archive.ubuntu.com/
  |__ubuntu/
    |__dists/
      |__xenial-backports/
      |__xenial-proposed/
      |__xenial-security/
      |__xenial-updates/
      |__xenial/
    |__indices/
    |__pool/
    |__project/
    |__ls-lr.gz
|__ id.archive.ubuntu.com/
  |__ubuntu/
  ...
```

## Build docker images

```bash
    $ docker build -t $NAME_IMAGES:$TAG_IMAGES .
```

## Run images

```bash
    $ docker run --name $NAME_CONTAINER -p 8080:80 -e RESYNC_PERIOD=$STRING -d $NAME_IMAGES:$TAG_IMAGES
```

## Run images using a volume

```bash
    $ docker run --name $NAME_CONTAINER -p 8080:80 -e RESYNC_PERIOD=$STRING -v /path/to/storage:/var/spool/apt-mirror -d $NAME_IMAGES:$TAG_IMAGES
```

or

```bash
    $ docker volume create $REPO_DATA
    $ $REPO_DATA
    $ docker run --name $NAME_CONTAINER -p 8080:80 -e RESYNC_PERIOD=$STRING -v $REPO_DATA:/var/spool/apt-mirror -d $NAME_IMAGES:$TAG_IMAGES
```
## Run using a custom configuration file `mirror.list`

```bash
    $ docker run --name $NAME_CONTAINER -p 8080:80 -e RESYNC_PERIOD=$STRING -v $REPO_DATA:/var/spool/apt-mirror -v /path/to/mirror.list:/mirror.list -d $NAME_IMAGES:$TAG_IMAGES
```

## Container viewing logs

```bash
    $ docker logs $NAME_CONTAINER
```

## Container shell access

```bash
    $ docker exec -it $NAME_CONTAINER bash 
```

## Config example `mirror.list` :

```list
############# config ##################
#
# set base_path    /var/spool/apt-mirror #this directory can be changed (directory dapat diubah sesuai kebutuhan)
#
# set mirror_path  $base_path/mirror     
# set skel_path    $base_path/skel
# set var_path     $base_path/var
set cleanscript $var_path/clean.sh
# set defaultarch  <running host architecture>
# set postmirror_script $var_path/postmirror.sh #mirror repos
# set run_postmirror 0
set nthreads     20
set _tilde 0
#
############# end config ##############

deb-i386 http://id.archive.ubuntu.com/ubuntu trusty main restricted universe multiverse
deb-i386 http://id.archive.ubuntu.com/ubuntu trusty-security main restricted universe multiverse
deb-i386 http://id.archive.ubuntu.com/ubuntu trusty-updates main restricted universe multiverse

deb-i386 http://id.archive.ubuntu.com/ubuntu trusty main/debian-installer restricted/debian-installer universe/debian-installer multiverse/debian-installer
deb-i386 http://id.archive.ubuntu.com/ubuntu trusty-security main/debian-installer restricted/debian-installer universe/debian-installer multiverse/debian-installer
deb-i386 http://id.archive.ubuntu.com/ubuntu trusty-updates main/debian-installer restricted/debian-installer universe/debian-installer multiverse/debian-installer

deb-i386 http://id.archive.ubuntu.com/ubuntu trusty main/dep11 restricted/dep11 universe/dep11 multiverse/dep11
deb-i386 http://id.archive.ubuntu.com/ubuntu trusty-security main/dep11 restricted/dep11 universe/dep11 multiverse/dep11
deb-i386 http://id.archive.ubuntu.com/ubuntu trusty-updates main/dep11 restricted/dep11 universe/dep11 multiverse/dep11

#clean old paket
clean http://id.archive.ubuntu.com/ubuntu
```