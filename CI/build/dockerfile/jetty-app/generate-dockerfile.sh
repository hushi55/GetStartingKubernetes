#!/bin/sh

app=$1

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
RUN mkdir -p /kingdee/jetty/domains/$app/logs
RUN mkdir -p /kingdee/jetty/domains/$app/bin
RUN mkdir -p /kingdee/jetty/domains/$app/etc
COPY bin/* /kingdee/jetty/domains/$app/bin/
COPY etc/* /kingdee/jetty/domains/$app/etc/

# deploy appcation
RUN mkdir -p /kingdee/webapp/root\\\$${app}/$app
COPY $app.war /tmp/
RUN unzip /tmp/$app.war -d /kingdee/webapp/root\\\$${app}/$app

# mount kingdee dir
VOLUME ["/kingdee/jetty/domains/$app/logs"]

# clean /tmp dir
RUN rm -rf /tmp/*

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
