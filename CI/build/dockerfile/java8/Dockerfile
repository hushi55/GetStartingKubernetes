# Centos jetty
#
# VERSION               0.0.1

FROM      kingdee/centos7:v1
MAINTAINER -10 <shi_hu@kingdee.com>

LABEL Description="This image is used to root fs of kingdee's weibo system" Vendor="Infrastructure Platform Group Products" Version="1.0"

COPY jdk-8u45-linux-x64.tar.gz /tmp/

## mkdir
# install jdk 8
RUN mkdir -p /kingdee/ && \
    tar -zxf /tmp/jdk-8u45-linux-x64.tar.gz -C /kingdee && \
	cd /kingdee && \
	mv  jdk1.8.0_45 jdk && \
	rm -rf /tmp/*
