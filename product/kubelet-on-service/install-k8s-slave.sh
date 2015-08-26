#!/bin/sh

## enable ip forward
sysctl -w net.ipv4.ip_forward=1

K8S_KUBE_IMAGE='gcr.io/google_containers/hyperkube:v0.21.2'
K8S_ETCD_IMAGE='gcr.io/google_containers/etcd:2.0.12'
K8S_FLANNL_IMAGE='quay.io/coreos/flannel:0.4.1'
K8S_FLANNL_SUBNET_CONF=10.100.0.0/16
K8S_FLANNL_CONF_FILE=/kingdee/kubernetes/bin/flanneld-subnet.env

KUBE_STATIC_POD_DIR_CONF=/etc/kubelet.d
KUBE_STATIC_K8S_DIR_CONF=/etc/kubernetes/manifests/

KUBE_HEAPSTER_CADVISOR_HOSTFILE=/etc/heapster.d

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

echo "========= cleaning iptables rules ..."
iptables --flush
iptables --flush -t nat

echo "========= static master api schedule controll static pods"
mkdir -p ${KUBE_STATIC_K8S_DIR_CONF}
cp ../k8s-static-slave/*.manifest ${KUBE_STATIC_K8S_DIR_CONF}

echo "========= static pods config "
mkdir -p ${KUBE_STATIC_POD_DIR_CONF}
cp ../k8s-static-nodes/* ${KUBE_STATIC_POD_DIR_CONF}

echo "========= static heapster config "
mkdir -p ${KUBE_HEAPSTER_CADVISOR_HOSTFILE}
mkdir -p /etc/cadvisor/
cp ../images/heapster/hosts.json ${KUBE_HEAPSTER_CADVISOR_HOSTFILE}
cp ../images/heapster/hosts.json /etc/cadvisor/container_hints.json

echo "========= install kubelet services "
sh ./kubelet.sh

