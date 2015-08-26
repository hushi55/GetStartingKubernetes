#!/bin/sh

cat <<EOF >/usr/lib/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service

[Service]
WorkingDirectory=/var/lib/kubelet
EnvironmentFile=-/etc/kubernetes/config
ExecStart=${KUBE_BIN_DIR}/kubelet \\
    ${KUBE_LOGTOSTDERR_FALSE} \\
    ${KUBE_LOG_LEVEL} \\
    ${KUBE_LOG_DIR} \\
	${KUBE_ALLOW_PRIV_TRUE} \\
	${KUBELET_ADDRESS} \\
	${KUBELET_API_SERVER} \\
	${KUBELET_ARGS}
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kubelet
systemctl stop kubelet
systemctl start kubelet