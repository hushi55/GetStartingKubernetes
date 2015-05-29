#!bin/sh

KUBE_BIN_DIR=/kingdee/kubernetes/bin
KUBE_LOGTOSTDERR=true
KUBE_LOG_LEVEL=4
KUBE_MASTER=172.20.10.221:8080
KUBE_SCHEDULER_ADDRESS=172.20.10.221

cat <<EOF >/usr/lib/systemd/system/scheduler.service
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=${KUBE_BIN_DIR}/kube-scheduler \\
    --logtostderr=${KUBE_LOGTOSTDERR} \\
    --v=${KUBE_LOG_LEVEL} \\
	--address=${KUBE_SCHEDULER_ADDRESS} \\
    --master=${KUBE_MASTER}
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable scheduler
systemctl stop scheduler
systemctl start scheduler