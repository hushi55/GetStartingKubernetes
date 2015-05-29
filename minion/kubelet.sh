#!/bin/sh

KUBE_BIN_DIR=/kingdee/kubernetes/bin
KUBE_LOGTOSTDERR=true
KUBE_LOG_LEVEL=4
KUBE_ETCD_SERVERS=http://172.20.10.221:4001
MINION_ADDRESS=172.20.10.222
MINION_PORT=10250
MINION_HOSTNAME=172.20.10.222
KUBE_ALLOW_PRIV=false
KUBE_API_SERVERS=http://172.20.10.221:8080

cat <<EOF >/usr/lib/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
After=docker.socket cadvisor.service
Requires=docker.socket

[Service]
ExecStart=${KUBE_BIN_DIR}/kubelet \\
    --logtostderr=${KUBE_LOGTOSTDERR} \\
    --v=${KUBE_LOG_LEVEL} \\
    --address=${MINION_ADDRESS} \\
	--api-servers=${KUBE_API_SERVERS} \\
    --port=${MINION_PORT} \\
    --hostname-override=${MINION_HOSTNAME} \\
    --allow-privileged=${KUBE_ALLOW_PRIV}
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kubelet
systemctl stop kubelet
systemctl start kubelet