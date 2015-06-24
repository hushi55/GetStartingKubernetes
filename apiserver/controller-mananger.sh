#!/bin/sh

KUBE_BIN_DIR=/kingdee/kubernetes/bin
KUBE_LOGTOSTDERR=false
KUBE_LOG_LEVEL=0
KUBE_LOG_DIR=/kingdee/kubernetes/logs
KUBE_MASTER=172.20.10.221:8080
KUBE_ADDRESS=0.0.0.0

cat <<EOF >/usr/lib/systemd/system/controller-manager.service
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=${KUBE_BIN_DIR}/kube-controller-manager \\
    --logtostderr=${KUBE_LOGTOSTDERR} \\
	--address=${KUBE_ADDRESS} \\
    --v=${KUBE_LOG_LEVEL} \\
	--log-dir=${KUBE_LOG_DIR} \\
    --master=${KUBE_MASTER}
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable controller-manager
systemctl stop controller-manager
systemctl start controller-manager