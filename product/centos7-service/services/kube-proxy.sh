#!/bin/sh

cat <<EOF >/usr/lib/systemd/system/kube-proxy.service
[Unit]
Description=Kubernetes Kubelet Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service

[Service]
WorkingDirectory=/var/lib/kubelet
EnvironmentFile=-/etc/kubernetes/config
ExecStart=\${KUBE_BIN_DIR}/kube-proxy \\
    \${KUBE_LOGTOSTDERR_FALSE} \\
    \${KUBE_LOG_LEVEL} \\
    \${KUBE_LOG_DIR} \\
	\${KUBE_MASTER} \\
	\${PROXY_BIND_ADDRESS} \\
	\${PROXY_ARGS}
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kube-proxy.service
systemctl stop kube-proxy.service
systemctl start kube-proxy.service