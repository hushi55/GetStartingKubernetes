# Centos jetty
#
# VERSION               0.0.1

FROM phusion/baseimage:0.9.15
MAINTAINER -10 <shi_hu@kingdee.com>

LABEL Description="This image is used to root fs of kingdee's weibo system" Vendor="Infrastructure Platform Group Products" Version="1.0"


RUN apt-get update 
RUN apt-get install -y libpcap0.8

#RUN yum install -y libpcap initscripts rsyslog

RUN wget https://download.elastic.co/beats/packetbeat/packetbeat_1.0.0-beta2_amd64.deb -o /tmp/packetbeat_1.0.0-beta2_amd64.deb \
		 && dpkg -i /tmp/packetbeat_1.0.0-beta2_amd64.deb \
		 && rm -f /tmp/packetbeat_1.0.0-beta2_amd64.deb

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /etc/packetbeat/
COPY packetbeat.yml /etc/packetbeat/

RUN mkdir -p /var/log/packetbeat

VOLUME ["/var/log/packetbeat"]
VOLUME ["/etc/supervisor/conf.d/"]

