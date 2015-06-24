#!bin/sh

echo "stoping per service ..."
systemctl stop apiserver
systemctl stop controller-manager
systemctl stop scheduler
systemctl stop etcd
systemctl disable flanneld
systemctl stop docker-bootstrap.socket
systemctl stop docker-bootstrap.service
systemctl stop docker.socket
systemctl stop docker.service
systemctl stop kubelet
systemctl stop proxy

systemctl disable apiserver
systemctl disable controller-manager
systemctl disable scheduler
systemctl disable etcd
systemctl disable flanneld
systemctl disable docker-bootstrap.socket
systemctl disable docker-bootstrap.service
systemctl disable docker.socket
systemctl disable docker.service
systemctl disable kubelet
systemctl disable proxy

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