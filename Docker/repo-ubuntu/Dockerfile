#
#                    ##        .
#              ## ## ##       ==
#           ## ## ## ##      ===
#       /""""""""""""""""\___/ ===
#  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
#       \______ o          __/
#         \    \        __/
#          \____\______/
#
#          |          |
#       __ |  __   __ | _  __   _
#      /  \| /  \ /   |/  / _\ |
#      \__/| \__/ \__ |\_ \__  |
#
# Dockerfile apt-mirror + apache2
#
# https://www.howtoforge.com/local_debian_ubuntu_mirror
#

FROM ubuntu:16.04

MAINTAINER Setyadhi Putra D <setyadhiputrad@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV RESYNC_PERIOD 24h

RUN apt-get update \
 && apt-get install --no-install-recommends -y apt-mirror apache2 \
 && apt-get autoclean

RUN rm -rf /etc/apt/mirror.list \
 && rm -rf /var/lib/apt/lists/*

EXPOSE 80

COPY mirror.list /mirror.list
COPY setup.sh /setup.sh

VOLUME ["/var/spool/apt-mirror"]

CMD ["/bin/bash", "setup.sh"]
