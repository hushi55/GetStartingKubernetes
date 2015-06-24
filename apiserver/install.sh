#!bin/sh

## dir mk
KUBE_LOG_DIR=/kingdee/kubernetes/logs

mkdir -p ${KUBE_LOG_DIR}

echo "installing etcd service ..."
sh ./etcd.sh

echo "installing apiserver service ..."
sh ./apiserver.sh

echo "installing controller-mananger service ..."
sh ./controller-mananger.sh

echo "installing scheduler service ..."
sh ./scheduler.sh