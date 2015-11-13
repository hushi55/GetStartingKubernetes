#!/bin/sh

## enable ip forward
sysctl -w net.ipv4.ip_forward=1

K8S_KUBE_IMAGE='gcr.io/google_containers/hyperkube:v0.21.2'
K8S_ETCD_IMAGE='gcr.io/google_containers/etcd:2.0.12'
K8S_FLANNL_IMAGE='quay.io/coreos/flannel:0.4.1'
K8S_FLANNL_SUBNET_CONF=10.100.0.0/16
K8S_FLANNL_CONF_FILE=/kingdee/kubernetes/bin/flanneld-subnet.env

echo "========= yum installing soft ..."
yum install -y zip unzip bzip2 tar gzip

echo "========= stoping per install k8s ..."
## stop per install k8s
systemctl stop docker.socket
systemctl stop docker.service
systemctl stop kubelet
systemctl disable docker.socket
systemctl disable docker.service
systemctl disable kubelet


echo "========= cleaning etcd config ..."
etcdctl -C 192.168.1.237:2379 rm /registry --recursive
etcdctl -C 192.168.1.237:2379 rm /skydns --recursive


echo "========= cleaning iptables rules ..."
iptables --flush
iptables --flush -t nat


echo "========= installing docker service ..."
sh ./docker-main.sh

echo "========= installing k8s docker-main kubernetes master ..."
sh ./k8s-api-server.sh 
sh ./k8s-kubelet-proxy.sh

