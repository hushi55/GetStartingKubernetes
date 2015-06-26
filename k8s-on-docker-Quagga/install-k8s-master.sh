#!/bin/sh

## enable ip forward
sysctl -w net.ipv4.ip_forward=1

K8S_KUBE_IMAGE='gcr.io/google_containers/hyperkube:v0.19.3'
K8S_ETCD_IMAGE='gcr.io/google_containers/etcd:2.0.12'
K8S_FLANNL_IMAGE='quay.io/coreos/flannel:0.4.1'
K8S_FLANNL_SUBNET_CONF=10.100.0.0/16
K8S_FLANNL_CONF_FILE=/kingdee/kubernetes/bin/flanneld-subnet.env

echo "========= yum installing soft ..."
yum install -y zip unzip bzip2 tar gzip

echo "========= stoping per install k8s ..."
## stop per install k8s
systemctl stop apiserver
systemctl stop controller-manager
systemctl stop scheduler
systemctl stop etcd
systemctl stop docker-bootstrap.socket
systemctl stop docker-bootstrap.service
systemctl stop docker.socket
systemctl stop docker.service
systemctl disable apiserver
systemctl disable controller-manager
systemctl disable scheduler
systemctl disable etcd
systemctl disable docker-bootstrap.socket
systemctl disable docker-bootstrap.service
systemctl disable docker.socket
systemctl disable docker.service


echo "========= installing docker-main ..."
rm  -rf /var/lib/docker
## run docker main
sh ./docker-main.sh


echo "========= installing Quagga ..."
docker run -d --name=router --privileges --net=host index.alauda.cn/georce/router

echo "========= installing docker-main kubernetes master ..."
sh ./k8s-api-server.sh 

