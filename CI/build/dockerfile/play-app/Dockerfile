# Centos jetty
#
# VERSION               0.0.1

FROM      kingdee/play:1.2.6
MAINTAINER -10 <shi_hu@kingdee.com>

LABEL Description="This image is used to root fs of kingdee's weibo system" Vendor="Infrastructure Platform Group Products" Version="1.0"

## install app
COPY *.zip /tmp/
RUN unzip /tmp/*.zip -d /kingdee/jarapp/
COPY application.conf /kingdee/jarapp/conf/

# cd to app dir
WORKDIR /kingdee/jarapp/

# clean /tmp dir
RUN rm -rf /tmp/*

