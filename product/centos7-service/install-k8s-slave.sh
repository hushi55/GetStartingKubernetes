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
systemctl stop  kube-apiserver.service
systemctl stop  kube-controller-manager.service
systemctl stop  kube-scheduler.service
systemctl stop  kubelet.service
systemctl stop  kube-proxy.service
systemctl disable docker.socket
systemctl disable docker.service
systemctl disable  kube-apiserver.service
systemctl disable  kube-controller-manager.service
systemctl disable  kube-scheduler.service
systemctl disable  kubelet.service
systemctl disable  kube-proxy.service

echo "========= cleaning iptables rules ..."
iptables --flush
iptables --flush -t nat

echo "========= copying k8s static pods ..."
KUBE_STATIC_POD_DIR_CONF=/etc/kubelet.d

rm -fr /etc/kubelet.d/
mkdir -p ${KUBE_STATIC_POD_DIR_CONF}

cp ../k8s-static-nodes/* ${KUBE_STATIC_POD_DIR_CONF}
rm -f ${KUBE_STATIC_POD_DIR_CONF}/cadvisor.yaml


echo "========= installing docker service ..."
sh ../docker-main.sh

echo "========= installing docker-main kubernetes kubelet and proxy ..."
mkdir -p /etc/kubernetes/
cp ./config/config		/etc/kubernetes/config
sh ./services/kubelet.sh
sh ./services/kube-proxy.sh

echo "========= docker cleaning exited and dead contain ..."
sh ./clern.sh

