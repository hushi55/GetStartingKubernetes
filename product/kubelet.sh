#!/bin/sh

KUBE_BIN_DIR=/kingdee/kubernetes/bin
KUBE_LOGTOSTDERR=false
KUBE_LOG_LEVEL=0
KUBE_LOG_DIR=/kingdee/kubernetes/logs
MINION_ADDRESS=0.0.0.0
MINION_PORT=10250
KUBE_ALLOW_PRIV=true
KUBE_API_SERVERS=http://172.20.10.221:8080
KUBE_DOCKER_RUN_DIR=/var/run/docker
KUBE_CLUSTER_DNS=10.100.100.100
KUBE_CLUSTER_DOMAIN=k8s.cluster.local

KUBE_STATIC_POD_DIR_CONF=/etc/kubelet.d

mkdir -p ${KUBE_LOG_DIR}

cat <<EOF >/usr/lib/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
After=docker.socket
Requires=docker.socket

[Service]
ExecStart=${KUBE_BIN_DIR}/kubelet \\
    --logtostderr=${KUBE_LOGTOSTDERR} \\
    --v=${KUBE_LOG_LEVEL} \\
    --address=${MINION_ADDRESS} \\
	--api-servers=${KUBE_API_SERVERS} \\
    --cluster-dns=${KUBE_CLUSTER_DNS} \\
    --config="${KUBE_STATIC_POD_DIR_CONF}" \\
	--allow-privileged=${KUBE_ALLOW_PRIV} \\
	--cluster-domain=${KUBE_CLUSTER_DOMAIN}
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kubelet
systemctl stop kubelet
systemctl start kubelet