#!/bin/sh

cat <<EOF >/usr/lib/systemd/system/confd.service
[Unit]
Description=confd for k8s Discovering services

[Service]
WorkingDirectory=/var/lib/kubelet
EnvironmentFile=-/etc/kubernetes/config
ExecStart=/kingdee/confd/bin/confd \\
			-interval=60 \\
			-backend etcd -node 192.168.1.237:2379 \\
			-confdir=/kingdee/confd/conf/
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable confd
systemctl start confd