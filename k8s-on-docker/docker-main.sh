#!/bin/sh

DOCKER_CONFIG=/etc/sysconfig/docker
KUBE_FLANNELD_SUBNET=/kingdee/kubernetes/bin/flanneld-subnet.env

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

source $DOCKER_CONFIG
source $KUBE_FLANNELD_SUBNET
cat <<EOF >/usr/lib/systemd/system/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.com
After=network.target docker.socket
Requires=docker.socket

[Service]
Type=notify
EnvironmentFile=-$DOCKER_CONFIG
EnvironmentFile=-$KUBE_FLANNELD_SUBNET
ExecStart=/usr/bin/docker -d --storage-driver=devicemapper \\ -H fd:// ${OPTIONS}  --bip=${FLANNEL_SUBNET}  --mtu=${FLANNEL_MTU}
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
### remove docker0
ip link set dev docker0 down
brctl delbr docker0

systemctl daemon-reload
systemctl enable docker
systemctl start docker
