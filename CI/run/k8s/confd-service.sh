#!/bin/sh

cat <<EOF >/usr/lib/systemd/system/confd.service
[Unit]
Description=confd for k8s Discovering services

[Service]
Type=notify
ExecStart=/kingdee/confd/bin/confd \\
			-interval=60 \\
			-backend etcd -node 192.168.1.237:2379 \\
			-confdir=/kingdee/confd/conf/
LimitNOFILE=1048576
LimitNPROC=1048576

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable confd
systemctl start confd