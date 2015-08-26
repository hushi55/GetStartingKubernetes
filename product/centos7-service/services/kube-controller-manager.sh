#!/bin/sh

source /etc/kubernetes/config

cat <<EOF >/usr/lib/systemd/system/kube-controller-manager.service
[Unit]
Description=Kubernetes Kubelet Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service

[Service]
WorkingDirectory=/var/lib/kubelet
EnvironmentFile=-/etc/kubernetes/config
ExecStart=${KUBE_BIN_DIR}/kube-controller-manager \\
    ${KUBE_LOGTOSTDERR_FALSE} \\
    ${KUBE_LOG_LEVEL} \\
    ${KUBE_LOG_DIR} \\
	${KUBE_MASTER} \\
	${KUBE_ADDRESS} \\
	${CONTROLLER_ARGS}
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kube-controller-manager.service
systemctl stop kube-controller-manager.service
systemctl start kube-controller-manager.service