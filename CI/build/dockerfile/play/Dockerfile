# Centos jetty
#
# VERSION               0.0.1

FROM      kingdee/java7:v1
MAINTAINER -10 <shi_hu@kingdee.com>

LABEL Description="This image is used to root fs of kingdee's weibo system" Vendor="Infrastructure Platform Group Products" Version="1.0"


# install play
COPY play-1.2.6.1.zip /tmp/
COPY start.sh /tmp/

RUN mkdir -p /kingdee/play/ && \
	unzip /tmp/play-1.2.6.1.zip -d /kingdee/play/ && \
	chmod +x /kingdee/play/play-1.2.6.1/play && \
	mkdir -p /kingdee/jarapp/ && \
	cp /tmp/start.sh /kingdee/jarapp/ && \
	chmod +x /kingdee/jarapp/start.sh && \
	rm -rf /tmp/*
	
WORKDIR /kingdee/jarapp/

CMD ["/bin/bash", "start.sh"]


#RUN unzip /tmp/play-1.2.6.1.zip -d /kingdee/play/
#
#RUN chmod +x /kingdee/play/play-1.2.6.1/play
#
#RUN mkdir -p /kingdee/jarapp/
#COPY start.sh /kingdee/jarapp/
#RUN chmod +x /kingdee/jarapp/start.sh
#
#WORKDIR /kingdee/jarapp/

#CMD ["/bin/bash", "start.sh"]
#
## clean /tmp dir
#RUN rm -rf /tmp/*
#