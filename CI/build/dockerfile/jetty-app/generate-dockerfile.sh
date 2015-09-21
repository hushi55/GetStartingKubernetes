#!/bin/sh

app=${1:-microblog}
grp=${2:-output}
branch=${3:-smoke}
typ=${4:-war}

date=`date +"%Y-%m-%d %H:%m:%S"`

cat <<EOF >./Dockerfile
# kingdee docker apps 
#
# VERSION               0.0.1

FROM  kingdee/jetty8:v1    
MAINTAINER -10 <shi_hu@kingdee.com>

LABEL Description="This image is used to deploy apps of kingdee's weibo system" Vendor="Infrastructure Platform Group Products" Version="1.0"

# copy global configure
COPY global.properties /kingdee/jetty/etc/

# expose port 10091
EXPOSE 10091

# install jetty start shell script
RUN mkdir -p /kingdee/jetty/domains/$app/{logs,etc,bin}
#RUN mkdir -p /kingdee/jetty/domains/$app/bin
#RUN mkdir -p /kingdee/jetty/domains/$app/etc
COPY bin/* /kingdee/jetty/domains/$app/bin/
COPY etc/* /kingdee/jetty/domains/$app/etc/

# deploy appcation
RUN mkdir -p /kingdee/webapp/root\\\$${app}/$app
#COPY $app.war /tmp/
RUN curl -GET http://192.168.1.50:8098/dkr/$grp/$branch/$typ/$app.$typ -o /tmp/$app.$typ && \
	unzip /tmp/$app.war -d /kingdee/webapp/root\\\$${app}/$app && \
	touch /kingdee/webapp/root\\\$${app}/$app/ping.html && \
	echo "ping succeed ! this image build by kingdee ${date} "  > /kingdee/webapp/root\\\$${app}/$app/ping.html && \
	rm -rf /tmp/*

# mount kingdee dir
VOLUME ["/kingdee/jetty/domains/$app/logs"]

# clean /tmp dir
#RUN rm -rf /tmp/*

# start apps
WORKDIR /kingdee/jetty/domains/$app/bin/
#RUN pwd
#RUN sh jetty.sh start
CMD ["/bin/sh", "jetty.sh", "run"]
#ENTRYPOINT ["/bin/sh", "jetty.sh", "start"]
#CMD ["/bin/sh", "jetty.sh", "run"]
#RUN chmod +x /kingdee/jetty/domains/$app/bin/*
#CMD ["./jetty.sh", "-d", "run"]
EOF
