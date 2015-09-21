# Centos jetty
#
# VERSION               0.0.1

FROM      centos
MAINTAINER -10 <shi_hu@kingdee.com>

LABEL Description="This image is used to root fs of kingdee's weibo system" Vendor="Infrastructure Platform Group Products" Version="1.0"

#COPY GraphicsMagick-1.3.21.tar.gz /tmp/

# install dependency soft

RUN yum -y install gcc automake autoconf libtool make
RUN yum -y install gcc gcc-c++
RUN yum -y install unzip tar net-tools lsof strace vim wget


## gm freetype lib
RUN curl http://172.20.10.220/gm-lib/freetype-2.6.tar.gz -o /tmp/freetype-2.6.tar.gz && \
	cd /tmp && \
	tar -zxvf freetype-2.6.tar.gz && \
	cd freetype-2.6 && \
	./configure && \
	make -j8 && \
	make install && \
	rm -rf /tmp/*
	
## gm JPEG lib
RUN curl http://172.20.10.220/gm-lib/jpegsrc.v9a.tar.gz -o /tmp/jpegsrc.v9a.tar.gz && \
	cd /tmp && \
	tar -zxvf jpegsrc.v9a.tar.gz && \
	cd jpeg-9a && \
	./configure && \
	make -j8 && \
	make install && \
	rm -rf /tmp/*
	
RUN curl http://172.20.10.220/gm-lib/jasper-1.900.1.zip -o /tmp/jasper-1.900.1.zip && \
	cd /tmp && \
	unzip jasper-1.900.1.zip && \
	cd jasper-1.900.1 && \
	./configure && \
	make -j8 && \
	make install && \
	rm -rf /tmp/*

####### gm png lib
RUN curl http://172.20.10.220/gm-lib/zlib-1.2.8.tar.gz -o /tmp/zlib-1.2.8.tar.gz && \
	cd /tmp && \
	tar -zxvf zlib-1.2.8.tar.gz && \
	cd zlib-1.2.8 && \
	./configure && \
	make -j8 && \
	make install && \
	rm -rf /tmp/*
	
RUN curl http://172.20.10.220/gm-lib/libpng-1.6.18.tar.gz -o /tmp/libpng-1.6.18.tar.gz && \
	cd /tmp && \
	tar -zxvf libpng-1.6.18.tar.gz && \
	cd libpng-1.6.18 && \
	./configure && \
	make -j8 && \
	make install && \
	rm -rf /tmp/*

## gm bzip lib
RUN curl http://172.20.10.220/gm-lib/bzip2-1.0.6.tar.gz -o /tmp/bzip2-1.0.6.tar.gz && \
	cd /tmp && \
	tar -zxvf bzip2-1.0.6.tar.gz && \
	cd bzip2-1.0.6 && \
	make -j8 && \
	make install && \
	rm -rf /tmp/*
	
## gm tiff lib
RUN curl http://172.20.10.220/gm-lib/tiff-4.0.5.tar.gz -o /tmp/tiff-4.0.5.tar.gz && \
	cd /tmp && \
	tar -zxvf tiff-4.0.5.tar.gz && \
	cd tiff-4.0.5 && \
	./configure && \
	make -j8 && \
	make install && \
	rm -rf /tmp/*
	
## gm  lcms library
RUN curl http://172.20.10.220/gm-lib/lcms2-2.7.tar.gz -o /tmp/lcms2-2.7.tar.gz && \
	cd /tmp && \
	tar -zxvf lcms2-2.7.tar.gz && \
	cd lcms2-2.7 && \
	./configure && \
	make -j8 && \
	make install && \
	rm -rf /tmp/*
	


## GraphicsMagick
RUN curl http://172.20.10.220/GraphicsMagick-1.3.21.tar.gz -o /tmp/GraphicsMagick-1.3.21.tar.gz && \
	cd /tmp && \
	tar -zxvf GraphicsMagick-1.3.21.tar.gz && \
	cd GraphicsMagick-1.3.21 && \
	./configure --disable-openmp && \
	make -j8 && \
	make install && \
	rm -rf /tmp/*
	
## tuning open file config
RUN echo "*               soft    nofile            1048576" >>	/etc/security/limits.conf  && \
	echo "*               hard    nofile            1048576" >>	/etc/security/limits.conf  && \
	echo "*               soft    nofile            1048576" >>	/etc/security/limits.d/20-nproc.conf	


## set asia/shanghai timezone
RUN rm -f /etc/localtime && \
	ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
