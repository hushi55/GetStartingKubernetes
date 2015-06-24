#!/bin/sh

KUBE_BIN_DIR=/kingdee/kubernetes/bin
ETCD_PEER_ADDR='http://0.0.0.0:2380,http://0.0.0.0:7001'
ETCD_ADDR='http://0.0.0.0:2379,http://0.0.0.0:4001'
ETCD_ADVERTISE_CLIEN='http://0.0.0.0:2379,http://0.0.0.0:4001'
ETCD_DATA_DIR=/kingdee/etcd/data
ETCD_NAME=kubernetes

! test -d $ETCD_DATA_DIR && mkdir -p $ETCD_DATA_DIR
cat <<EOF >/usr/lib/systemd/system/etcd.service
[Unit]
Description=Etcd Server

[Service]
ExecStart=${KUBE_BIN_DIR}/etcd \\
	--data-dir $ETCD_DATA_DIR \\
	--advertise-client-urls ${ETCD_ADVERTISE_CLIEN} \\
	--listen-client-urls ${ETCD_ADDR} \\
	--listen-peer-urls ${ETCD_PEER_ADDR} \\
	--name $ETCD_NAME \\

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable etcd
systemctl stop etcd
systemctl start etcd