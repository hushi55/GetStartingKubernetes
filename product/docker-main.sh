#!/bin/sh

DOCKER_CONFIG=/etc/sysconfig/docker

## add group docker
groupadd docker
## install brctl
yum install -y bridge-utils


cat <<EOF >$DOCKER_CONFIG
OPTIONS=--selinux-enabled=false 
EOF

cat <<EOF >/usr/lib/systemd/system/docker.socket
[Unit]
Description=Docker Socket for the API

[Socket]
ListenStream=/var/run/docker.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker

[Install]
WantedBy=sockets.target
EOF


#--storage-driver=devicemapper \\
#			--storage-opt dm.override_udev_sync_check=true \\
#**-l**, **--log-level**="*debug*|*info*|*error*|*fatal*""

source $DOCKER_CONFIG
cat <<EOF >/usr/lib/systemd/system/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.com
After=network.target docker.socket
Requires=docker.socket

[Service]
Type=notify
EnvironmentFile=-$DOCKER_CONFIG
ExecStart=/usr/bin/docker \\
			daemon \\
			--log-level=warn \\
			--storage-opt dm.override_udev_sync_check=true \\
			-H unix:///var/run/docker.sock \\
			${OPTIONS}
LimitNOFILE=1048576
LimitNPROC=1048576

[Install]
Also=docker.socket
EOF

## 
#systemctl stop docker.socket
#systemctl disable docker.socket
#systemctl stop docker.service
#systemctl disable docker.service
#
### remove docker0 can not rm flannl docker br
#ip link set dev docker0 down
#brctl delbr docker0
#ip=`ifconfig  | grep 'inet' | grep -v '127.0.0.1'| grep -v '10.100' | grep -v 'inet6' |  awk '{ print $2}' | awk -F'.' '{print $4}'`
#bip='10.100.'${ip}'.0/24'
#docker -d --bip=${bip}


echo "========= cleaning iptables rules ..."
iptables --flush
iptables --flush -t nat

systemctl daemon-reload
systemctl enable docker
systemctl start docker

echo "========= docker cleaning exited and dead contain ..."
docker ps -a | grep -E 'Exited|Dead' | awk '{print $1}'  | xargs --no-run-if-empty docker rm -f


## load images
#echo "========= installing docker-main images ..."
#docker load -i /home/k8s.all.tar
#docker load -i /root/flannl-imgae.tar
#docker load -i /root/hyperkube-v0.19.3.tar
