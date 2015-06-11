#!/bin/sh

KUBE_BIN_DIR=/kingdee/kubernetes/bin
KUBE_LOGTOSTDERR=false
KUBE_LOG_LEVEL=0
KUBE_ETCD_SERVERS=http://172.20.10.221:4001
KUBE_FLANNELD_LOG=/kingdee/kubernetes/logs
KUBE_FLANNELD_SUBNET="/kingdee/kubernetes/bin/flanneld-subnet.env"
KUBE_FLANNELD_LAN=eth0
KUBE_FLANNELD_ETCD_PREFIX="/kingdee/network/flanneld01"

cat <<EOF >/usr/lib/systemd/system/flanneld.service
[Unit]
Description=Flanneld overlay  network

[Service]
ExecStart=${KUBE_BIN_DIR}/flanneld \\
    -logtostderr=${KUBE_LOGTOSTDERR} \\
    -etcd-endpoints=${KUBE_ETCD_SERVERS} \\
    -log_dir=${KUBE_FLANNELD_LOG} \\
    -v=${KUBE_LOG_LEVEL} \\
    -iface=${KUBE_FLANNELD_LAN} \\
    -etcd-prefix=${KUBE_FLANNELD_ETCD_PREFIX} \\
    -subnet-file=${KUBE_FLANNELD_SUBNET} 
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable flanneld
systemctl stop flanneld
systemctl start flanneld
