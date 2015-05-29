#!/bin/sh

KUBE_BIN_DIR=/kingdee/kubernetes/bin
KUBE_LOGTOSTDERR=true
KUBE_LOG_LEVEL=4
KUBE_BIND_ADDRESS=172.20.10.221
KUBE_ETCD_SERVERS=http://172.20.10.221:4001
KUBE_MASTER=http://172.20.10.221:8080

cat <<EOF >/usr/lib/systemd/system/proxy.service
[Unit]
Description=Kubernetes Proxy
# the proxy crashes if etcd isn't reachable.
# https://github.com/GoogleCloudPlatform/kubernetes/issues/1206
After=network.target

[Service]
ExecStart=${KUBE_BIN_DIR}/kube-proxy \\
    --logtostderr=${KUBE_LOGTOSTDERR} \\
    --v=${KUBE_LOG_LEVEL} \\
    --bind-address=${KUBE_BIND_ADDRESS} \\
    --master=${KUBE_ETCD_SERVERS} 
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable proxy
systemctl stop proxy
systemctl start proxy