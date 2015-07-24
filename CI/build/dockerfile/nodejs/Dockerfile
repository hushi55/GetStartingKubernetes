# Centos jetty
#
# VERSION               0.0.1

FROM      kingdee/centos7:v1
MAINTAINER tma <tianxiang_ma@kingdee.com>

LABEL Description="This image is used to root fs of kingdee's nodejs app" Vendor="Infrastructure Platform Group Products" Version="1.0"

# Enable EPEL for Node.js
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
# Install Node.js and npm
RUN yum install -y npm
