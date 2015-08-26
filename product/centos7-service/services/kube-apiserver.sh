#!/bin/sh

source ../config/config

cat <<EOF >/usr/lib/systemd/system/kube-apiserver.service
[Unit]
Description=Kubernetes Kubelet Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service

[Service]
WorkingDirectory=/var/lib/kubelet
EnvironmentFile=-/etc/kubernetes/config
ExecStart=${KUBE_BIN_DIR}/kube-apiserver \\
    ${KUBE_LOGTOSTDERR_FALSE} \\
    ${KUBE_LOG_LEVEL} \\
    ${KUBE_LOG_DIR} \\
	${KUBE_ALLOW_PRIV_TRUE} \\
	${API_SERVER_ETCD_SERVERS} \\
	${API_SERVER_IP_RANGE} \\
	${API_SERVER_ARGS
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kube-apiserver.service
systemctl stop kube-apiserver.service
systemctl start kube-apiserver.service