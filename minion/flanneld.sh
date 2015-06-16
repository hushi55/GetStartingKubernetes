#!/bin/sh

KUBE_BIN_DIR=/kingdee/kubernetes/bin
KUBE_LOGTOSTDERR=false
KUBE_LOG_LEVEL=0
KUBE_ETCD_SERVERS=http://172.20.10.221:4001
KUBE_FLANNELD_LOG=/kingdee/kubernetes/logs
KUBE_FLANNELD_SUBNET="/kingdee/kubernetes/bin/flanneld-subnet.env"
KUBE_FLANNELD_LAN=eth0
KUBE_ETCDCTL=${KUBE_BIN_DIR}/etcdctl
HOSTNAME=`hostname`
KUBE_FLANNELD_ETCD_PREFIX="/kingdee/network/flannel_${HOSTNAME}"
KUBE_FLANNEL_SUBNET=10.100.0.0/16

cat <<EOF >/usr/lib/systemd/system/flanneld.service
[Unit]
Description=Flanneld overlay  network

[Service]
EnvironmentFile=/etc/environment
ExecStartPre=-/bin/bash -c "until ${KUBE_ETCDCTL} \\ 
			-C ${KUBE_ETCD_SERVERS} \\
			set ${KUBE_FLANNELD_ETCD_PREFIX}/config \\ 
			'{\"Network\": \"${KUBE_FLANNEL_SUBNET}\"}'; \\
				do echo \"waiting for etcd to become available...\"; \\
				sleep 5; done"
				
ExecStart=${KUBE_BIN_DIR}/flanneld \\
    -logtostderr=${KUBE_LOGTOSTDERR} \\
    -etcd-endpoints=${KUBE_ETCD_SERVERS} \\
    -log_dir=${KUBE_FLANNELD_LOG} \\
    -v=${KUBE_LOG_LEVEL} \\
    -iface=${KUBE_FLANNELD_LAN} \\
    #-subnet-file=${KUBE_FLANNELD_SUBNET} \\
    -etcd-prefix=${KUBE_FLANNELD_ETCD_PREFIX} 
    
ExecStartPost=-/bin/bash -c \\
		"until [ -e /run/flannel/subnet.env ]; \\
		 do echo \"waiting for write.\"; sleep 3; done"
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable flanneld
systemctl stop flanneld
systemctl start flanneld
