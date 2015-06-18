#!/bin/sh

KUBE_ETCD_SERVERS=http://172.20.10.221:4001
KUBE_API_ADDRESS=0.0.0.0
KUBE_API_PORT=8080
MINION_PORT=10250
KUBE_ALLOW_PRIV=false
KUBE_SERVICE_ADDRESSES=10.100.0.0/16
KUBE_LOG_DIR=/kingdee/kubernetes/logs
KUBE_LOGTOSTDERR=false
KUBE_LOG_LEVEL=0
KUBE_BIN_DIR=/kingdee/kubernetes/bin


cat <<EOF >/usr/lib/systemd/system/apiserver.service
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
#User=kube
ExecStart=${KUBE_BIN_DIR}/kube-apiserver  \
	--v=${KUBE_LOG_LEVEL} \
	--logtostderr=${KUBE_LOGTOSTDERR}  \
	--log-dir=${KUBE_LOG_DIR} \
	--etcd-servers=${KUBE_ETCD_SERVERS} \
	--insecure-bind-address=${KUBE_API_ADDRESS} \
	--insecure-port=${KUBE_API_PORT} \
	--kubelet-port=${MINION_PORT} \
	--allow-privileged=${KUBE_ALLOW_PRIV} \
	--service-cluster-ip-range=${KUBE_SERVICE_ADDRESSES}
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable apiserver
systemctl stop apiserver
systemctl start apiserver