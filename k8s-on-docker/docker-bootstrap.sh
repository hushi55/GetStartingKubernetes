#!/bin/sh

## add group docker
groupadd docker
## install brctl
yum install -y bridge-utils

DOCKER_CONFIG=/etc/sysconfig/docker

cat <<EOF >$DOCKER_CONFIG
OPTIONS=--selinux-enabled=false 
EOF

cat <<EOF >/usr/lib/systemd/system/docker-bootstrap.socket
[Unit]
Description=Docker Socket for the API

[Socket]
ListenStream=/var/run/docker-bootstrap.sock
SocketMode=0660
SocketUser=root
SocketGroup=docker

[Install]
WantedBy=sockets.target
EOF

source $DOCKER_CONFIG
cat <<EOF >/usr/lib/systemd/system/docker-bootstrap.service
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.com
After=network.target docker-bootstrap.socket
Requires=docker-bootstrap.socket

[Service]
Type=notify
EnvironmentFile=-$DOCKER_CONFIG
ExecStart=/usr/bin/docker -d \\
			-H unix:///var/run/docker-bootstrap.sock \\
			-p /var/run/docker-bootstrap.pid --iptables=false \\
			--ip-masq=false --bridge=none \\
			--graph=/var/lib/docker-bootstrap \\
			> /var/log/docker-bootstrap.log 2>&1
LimitNOFILE=1048576
LimitNPROC=1048576

[Install]
Also=docker-bootstrap.socket
EOF

systemctl daemon-reload
systemctl enable docker-bootstrap.service
systemctl start docker-bootstrap.service


