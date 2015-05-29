#!/bin/sh

KUBE_BIN_DIR=/kingdee/kubernetes/bin
KUBE_LOGTOSTDERR=true
KUBE_LOG_LEVEL=4
KUBE_MASTER=172.20.10.221:8080
KUBE_ADDRESS=172.20.10.221
MINION_ADDRESSES=172.20.10.222,172.20.10.223

cat <<EOF >/usr/lib/systemd/system/controller-manager.service
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=${KUBE_BIN_DIR}/kube-controller-manager \\
    --logtostderr=${KUBE_LOGTOSTDERR} \\
	--address=${KUBE_ADDRESS} \\
    --v=${KUBE_LOG_LEVEL} \\
	--machines=${MINION_ADDRESSES} \\
    --master=${KUBE_MASTER}
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable controller-manager
systemctl stop controller-manager
systemctl start controller-manager