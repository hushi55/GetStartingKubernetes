# Centos jetty
#
# VERSION               0.0.1

FROM      kingdee/centos7:v1
MAINTAINER -10 <shi_hu@kingdee.com>

LABEL Description="This image is used to root fs of kingdee's weibo system" Vendor="Infrastructure Platform Group Products" Version="1.0"

#COPY jdk-7u80-linux-x64.tar.gz /tmp/ 

## mkdir
# install jdk 7
RUN curl http://172.20.10.220/jdk-7u80-linux-x64.tar.gz -o /tmp/jdk-7u80-linux-x64.tar.gz && \
	mkdir -p /kingdee/ && \
    tar -zxf /tmp/jdk-7u80-linux-x64.tar.gz -C /kingdee && \
	cd /kingdee && \
	mv  jdk1.7.0_80 jdk && \
	rm -rf /tmp/*
