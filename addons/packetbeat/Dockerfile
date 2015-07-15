# Centos jetty
#
# VERSION               0.0.1

FROM      centos
MAINTAINER -10 <shi_hu@kingdee.com>

LABEL Description="This image is used to root fs of kingdee's weibo system" Vendor="Infrastructure Platform Group Products" Version="1.0"


RUN sudo yum install libpcap

COPY packetbeat-1.0.0-beta2-x86_64.rpm packetbeat-1.0.0-beta2-x86_64.rpm

RUN sudo rpm -vi packetbeat-1.0.0-beta2-x86_64.rpm

RUN mkdir -p /etc/packetbeat/

COPY packetbeat.yml /etc/packetbeat/