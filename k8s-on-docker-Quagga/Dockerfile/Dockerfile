# Centos quagga for docker network
#
# VERSION               0.0.1

FROM      centos
MAINTAINER -10 <shi_hu@kingdee.com>

LABEL Description="This image is used to docker netwokr soultion base route" Vendor="Infrastructure Platform Group Products" Version="0.0.1"

# install dependency soft
RUN yum -y groupinstall "Development Tools"
RUN yum -y install texinfo
RUN yum -y install unzip tar net-tools lsof strace vim

COPY quagga-0.99.24.1.tar.gz /tmp/


# decompression tar
WORKDIR /tmp
RUN tar -zxvf quagga-0.99.24.1.tar.gz
WORKDIR  /tmp/quagga-0.99.24.1

# compile and install

RUN mkdir -p /etc/quagga
RUN mkdir -p /var/log/quagga/ && chown quagga:quagga /var/log/quagga
RUN mkdir -p /var/run/quagga/ && chown quagga:quagga /var/run/quagga
RUN adduser quagga
#RUN groupadd quagga

#RUN ./configure --enable-vtysh --enable-user=root --enable-group=root –enable-vty-group=root --sysconfdir=/etc/quagga –libdir=/lib
RUN ./configure --sysconfdir=/etc/quagga --disable-doc  --localstatedir=/var/run/quagga 
RUN make -j8 && sudo make install

# config
COPY zebra.conf /etc/quagga/zebra.conf
COPY ospfd.conf /etc/quagga/ospfd.conf


# clean /tmp dir
#RUN rm -rf /tmp/*


## run zebra
CMD ["zebra -d"]








