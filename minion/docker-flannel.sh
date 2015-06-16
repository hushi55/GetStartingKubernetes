#!/bin/sh

DOCKER_CONFIG=/etc/sysconfig/docker
DOCKER_FLANNELD_SUBNET=10.100.0.0/16

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
cat <<EOF >/usr/lib/systemd/system/docker.service
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.com
After=network.target docker.socket
Requires=docker.socket

[Service]
Type=notify
EnvironmentFile=-$DOCKER_CONFIG
ExecStart=/usr/bin/docker -d -H fd:// $OPTIONS --bip=${DOCKER_FLANNELD_SUBNET}
LimitNOFILE=1048576
LimitNPROC=1048576

[Install]
Also=docker.socket
EOF

## 
systemctl stop docker.socket
systemctl disable docker.socket
systemctl stop docker.service
systemctl disable docker.service

## remove docker0
ip link set dev docker0 down
brctl delbr docker0

systemctl daemon-reload
systemctl enable docker
systemctl start docker
