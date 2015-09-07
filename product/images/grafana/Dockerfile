# Centos jetty
#
# VERSION               0.0.1

FROM kubernetes/heapster_grafana:v0.7
MAINTAINER -10 <shi_hu@kingdee.com>

USER root

RUN echo "http://dl-4.alpinelinux.org/alpine/v3.1/main" > /etc/apk/repositories && \
	echo "http://nl.alpinelinux.org/alpine/v3.1/main" >> /etc/apk/repositories && \
	echo "#http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
	echo "#http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	echo " " >> /etc/apk/repositories && \
	echo "http://dl-2.alpinelinux.org/alpine/v3.1/main" >> /etc/apk/repositories && \
	echo "#http://dl-2.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
	echo "#http://dl-2.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	echo " " >> /etc/apk/repositories && \
	setup-apkrepos -r && \
	echo "Hongkong" | setup-timezone -i && \
	echo "Asia/Shanghai" > /etc/TZ
	
USER nobody