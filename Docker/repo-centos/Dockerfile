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
#
# 
#

FROM centos:7

MAINTAINER Setyadhi Putra D <setyadhiputrad@gmail.com>

RUN yum -y install ruby rubygems ruby-devel rsync createrepo \
 && yum -y update \
 && yum clean all

RUN gem install bundler

COPY config.yaml /config.yaml
COPY yum_mirror.rb /yum_mirror.rb
COPY Gemfile /Gemfile

RUN cd / && bundle install

VOLUME ["/mirror"]

#CMD ["/bin/bash", "yum_mirror.rb"]
CMD /yum_mirror.rb
