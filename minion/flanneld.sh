#!/bin/sh

KUBE_BIN_DIR=/kingdee/kubernetes/bin
KUBE_LOGTOSTDERR=false
KUBE_LOG_LEVEL=0
KUBE_ETCD_SERVERS=http://172.20.10.221:4001
KUBE_BIN_DIR=/kingdee/kubernetes/logs

cat <<EOF >/usr/lib/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
After=docker.socket cadvisor.service
Requires=docker.socket

[Service]
ExecStart=${KUBE_BIN_DIR}/flanneld \\
    --logtostderr=${KUBE_LOGTOSTDERR} \\
    -etcd-endpoints=${KUBE_ETCD_SERVERS} \\
    -log_dir=${KUBE_BIN_DIR} \\
    --v=${KUBE_LOG_LEVEL} \\
    -subnet-file=${KUBE_BIN_DIR}/flanneld-subnet.env 
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable flanneld
systemctl stop flanneld
systemctl start flanneld
