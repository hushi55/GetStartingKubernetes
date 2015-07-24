# Centos jetty
#
# VERSION               0.0.1

FROM      kingdee/java8:v1
MAINTAINER -10 <shi_hu@kingdee.com>

LABEL Description="This image is used to root fs of kingdee's weibo system" Vendor="Infrastructure Platform Group Products" Version="1.0"

COPY *.zip /tmp/
COPY start.sh /tmp/

# mkdir for rest
RUN mkdir -p /kingdee/jarapp/rest/logs && \
	unzip /tmp/*.zip -d /kingdee/jarapp/rest && \
	cd /kingdee/jarapp/rest/jar/ && \
	unzip *.jar && \
	cd /kingdee/jarapp/rest && \
	cp /tmp/start.sh /kingdee/jarapp/rest/ && \
	main_class=`cat /kingdee/jarapp/rest/bin/start.sh | grep 'MAIN_CLASS="'` && sed  '1a '${main_class}'' -i start.sh && \
	rm -rf /tmp/*
	
WORKDIR /kingdee/jarapp/rest

CMD ["/bin/sh", "start.sh"]


# mkdir for rest
#RUN mkdir -p /kingdee/jarapp/rest
#RUN mkdir -p /kingdee/jarapp/rest/logs
#
#COPY *.zip /tmp/
#
#RUN unzip /tmp/*.zip -d /kingdee/jarapp/rest
#
#WORKDIR /kingdee/jarapp/rest/jar/
#RUN unzip *.jar
#
#WORKDIR /kingdee/jarapp/rest
#
#COPY start.sh /kingdee/jarapp/rest/
#
### read /bin/start.sh main class to rest/start.sh
#RUN main_class=`cat /kingdee/jarapp/rest/bin/start.sh | grep 'MAIN_CLASS="'` && sed  '1a '${main_class}'' -i start.sh
#
## clean /tmp dir
#RUN rm -rf /tmp/*
#
#CMD ["/bin/sh", "start.sh"]
