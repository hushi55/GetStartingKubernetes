#!/bin/sh

curl -GET https://github.com/coreos/flannel/releases/download/v0.5.1/flannel-0.5.1-linux-amd64.tar.gz -o /tmp/flannel-0.5.1-linux-amd64.tar.gz

tar -zxcf /tmp/flannel-0.5.1-linux-amd64.tar.gz -C /tmp

cp /tmp/flannel-0.5.1/flanneld /usr/bin/
chmod +x /usr/bin/flanneld

cp flannel-0.5.1/flanneld /etc/init.d/flannel

chkconfig --add flannel
chmod +x /etc/init.d/flannel
service flannel start

