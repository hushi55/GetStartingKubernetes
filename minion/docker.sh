#!/bin/sh

DOCKER_BRIDGE=kbr0
DOCKER_CONFIG=/etc/sysconfig/docker
DOCKER_FLANNELD_SUBNET=10.252.2.0/24

## create Linux bridge
brctl addbr kbr0
cat <<EOF> /etc/sysconfig/network-scripts/ifcfg-kbr0
DEVICE=kbr0
ONBOOT=yes
BOOTPROTO=static
IPADDR=172.17.1.1
NETMASK=255.255.255.0
GATEWAY=172.17.1.0
USERCTL=no
TYPE=Bridge
IPV6INIT=no
EOF
systemctl restart network
 
## Install Docker
wget https://get.docker.com/builds/Linux/x86_64/docker-latest -O /usr/bin/docker
chmod +x /usr/bin/docker

cat <<EOF >$DOCKER_CONFIG
OPTIONS=--selinux-enabled=false --bip=${DOCKER_FLANNELD_SUBNET}
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
cat <<EOF >/usr/lib/systemd/system/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.com
After=network.target docker.socket
Requires=docker.socket

[Service]
Type=notify
EnvironmentFile=-$DOCKER_CONFIG
ExecStart=/usr/bin/docker -d --bridge=$DOCKER_BRIDGE -H fd:// $OPTIONS 
LimitNOFILE=1048576
LimitNPROC=1048576

[Install]
Also=docker.socket
EOF

## 
systemctl stop docker
systemctl disable docker

## remove docker0
ip link set dev docker0 down
brctl delbr docker0

systemctl daemon-reload
systemctl enable docker
systemctl start docker
