#!/bin/sh

#wget https://github.com/coreos/flannel/releases/download/v0.5.1/flannel-0.5.1-linux-amd64.tar.gz -o /tmp/flannel-0.5.1-linux-amd64.tar.gz

tar -zxvf flannel-0.5.1-linux-amd64.tar.gz 

cp ./flannel-0.5.1/flanneld /usr/bin/
chmod +x /usr/bin/flanneld

cp -f ./flannel /etc/init.d/

chkconfig --add flannel
chmod +x /etc/init.d/flannel
service flannel start

