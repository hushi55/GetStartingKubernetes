# Centos jetty
#
# VERSION               0.0.1

FROM      kingdee/centos7:v1
MAINTAINER tma <tianxiang_ma@kingdee.com>

LABEL Description="This image is used to root fs of kingdee's nodejs app" Vendor="Infrastructure Platform Group Products" Version="1.0"

# Enable EPEL for Node.js
#RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
# Install Node.js and npm
#RUN yum install -y npm

#ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 5.0.0

RUN curl http://172.20.10.220/node-v$NODE_VERSION-linux-x64.tar.gz -o /tmp/node-v$NODE_VERSION-linux-x64.tar.gz \
 	&& tar -xzf /tmp/node-v$NODE_VERSION-linux-x64.tar.gz -C /usr/local --strip-components=1 \
  	&& rm -rf /tmp/*
