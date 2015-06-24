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

KUBE_LOG_DIR=/kingdee/kubernetes/logs

## clean
echo "cleaning ..."
rm -rf /kingdee/kubernetes/logs/*

## dir mk
mkdir -p ${KUBE_LOG_DIR}

echo "installing flanneld service ..."
sh ./flanneld.sh

echo "installing docker service ..."
sh ./docker-flannel.sh

echo "installing kubelet service ..."
sh ./kubelet.sh

echo "installing proxy service ..."
sh ./proxy.sh