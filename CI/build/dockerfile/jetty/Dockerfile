# Centos jetty
#
# VERSION               0.0.1

FROM      kingdee/java8:v1
MAINTAINER -10 <shi_hu@kingdee.com>

LABEL Description="This image is used to root fs of kingdee's weibo system" Vendor="Infrastructure Platform Group Products" Version="1.0"

COPY jetty-distribution-8.1.17.v20150415.zip /tmp/

RUN  cd  /tmp && \
	 unzip /tmp/jetty-distribution-8.1.17.v20150415.zip -d /kingdee/ && \
	 cd /kingdee && \
	 mv jetty-distribution-8.1.17.v20150415 jetty && \
	 rm -rf /kingdee/jetty/webapps/* && \
	 rm -rf /kingdee/jetty/contexts/* && \
	 mv /kingdee/jetty/start.ini /kingdee/jetty/start.ini.bak && \
	 rm -rf /tmp/*
	 
# install three lib jars
COPY ext/* /kingdee/jetty/lib/ext/

## install jetty 8
#WORKDIR /tmp
#RUN unzip /tmp/jetty-distribution-8.1.17.v20150415.zip -d /kingdee/
#WORKDIR /kingdee
#RUN mv jetty-distribution-8.1.17.v20150415 jetty
#
## clean jetty default apps
#RUN rm -rf /kingdee/jetty/webapps/*
#RUN rm -rf /kingdee/jetty/contexts/*
#RUN mv /kingdee/jetty/start.ini /kingdee/jetty/start.ini.bak
#
## install three lib jars
#COPY ext/* /kingdee/jetty/lib/ext/
#
## clean /tmp dir
#RUN rm -rf /tmp/*
