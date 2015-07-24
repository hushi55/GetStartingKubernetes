# Centos jetty
#
# VERSION               0.0.1

FROM      centos
MAINTAINER -10 <shi_hu@kingdee.com>

LABEL Description="This image is used to root fs of kingdee's weibo system" Vendor="Infrastructure Platform Group Products" Version="1.0"

COPY GraphicsMagick-1.3.21.tar.gz /tmp/

# install dependency soft
RUN yum -y install unzip tar net-tools lsof strace vim gcc make && \
	cd /tmp && \
	tar -zxvf GraphicsMagick-1.3.21.tar.gz && \
	cd GraphicsMagick-1.3.21 && \
	./configure --disable-openmp && \
	make -j8 && \
	make install && \
	rm -rf /tmp/*


#WORKDIR /tmp
#
#RUN tar -zxvf GraphicsMagick-1.3.21.tar.gz
#
#WORKDIR GraphicsMagick-1.3.21
#
#RUN ./configure --disable-openmp && \
#		make && \
#		make install && \
#		rm -rf /tmp/*

# clean /tmp dir
#RUN rm -rf /tmp/*
