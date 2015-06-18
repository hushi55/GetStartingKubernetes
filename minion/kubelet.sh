#!/bin/sh

KUBE_BIN_DIR=/kingdee/kubernetes/bin
KUBE_LOGTOSTDERR=false
KUBE_LOG_LEVEL=0
KUBE_LOG_DIR=/kingdee/kubernetes/logs
MINION_ADDRESS=0.0.0.0
MINION_PORT=10250
KUBE_ALLOW_PRIV=false
KUBE_API_SERVERS=http://172.20.10.221:8080
KUBE_DOCKER_RUN_DIR=/var/run/docker

cat <<EOF >/usr/lib/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
After=docker.socket cadvisor.service
Requires=docker.socket

[Service]
ExecStart=${KUBE_BIN_DIR}/kubelet \\
    --logtostderr=${KUBE_LOGTOSTDERR} \\
    --v=${KUBE_LOG_LEVEL} \\
    --log-dir=${KUBE_LOG_DIR} \\
    --address=${MINION_ADDRESS} \\
	--api-servers=${KUBE_API_SERVERS} \\
    --port=${MINION_PORT} \\
    --docker-run=${KUBE_DOCKER_RUN_DIR} \\
    --allow-privileged=${KUBE_ALLOW_PRIV}
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kubelet
systemctl stop kubelet
systemctl start kubelet