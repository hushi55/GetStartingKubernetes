#!/bin/sh

KUBE_BIN_DIR=/kingdee/kubernetes/bin
KUBE_LOGTOSTDERR=false
KUBE_LOG_LEVEL=0
KUBE_LOG_DIR=/kingdee/kubernetes/logs
KUBE_BIND_ADDRESS=0.0.0.0
KUBE_MASTER=http://172.20.10.221:8080

mkdir -p ${KUBE_LOG_DIR}

cat <<EOF >/usr/lib/systemd/system/proxy.service
[Unit]
Description=Kubernetes Proxy
# the proxy crashes if etcd isn't reachable.
# https://github.com/GoogleCloudPlatform/kubernetes/issues/1206
After=network.target

[Service]
ExecStart=${KUBE_BIN_DIR}/kube-proxy \\
    --logtostderr=${KUBE_LOGTOSTDERR} \\
    --log-dir=${KUBE_LOG_DIR} \\
    --v=${KUBE_LOG_LEVEL} \\
    --bind-address=${KUBE_BIND_ADDRESS} \\
    --master=${KUBE_MASTER} 
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable proxy
systemctl stop proxy
systemctl start proxy