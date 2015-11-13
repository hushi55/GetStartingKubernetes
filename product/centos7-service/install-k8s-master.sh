#!/bin/sh

## enable ip forward
sysctl -w net.ipv4.ip_forward=1

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


echo "========= cleaning etcd config ..."
etcdctl -C 192.168.1.237:2379 rm /registry --recursive
etcdctl -C 192.168.1.237:2379 rm /skydns --recursive



echo "========= cleaning iptables rules ..."
iptables --flush
iptables --flush -t nat


echo "========= installing docker service ..."
sh ../docker-main.sh

echo "========= copying k8s static pods ..."
KUBE_STATIC_POD_DIR_CONF=/etc/kubelet.d

rm -fr /etc/kubelet.d/
mkdir -p ${KUBE_STATIC_POD_DIR_CONF}

cp ../k8s-static-nodes/* ${KUBE_STATIC_POD_DIR_CONF}
rm -f ${KUBE_STATIC_POD_DIR_CONF}/cadvisor.yaml

echo "========= installing k8s docker-main kubernetes master ..."
mkdir -p /etc/kubernetes/
mkdir -p /var/log/k8s
cp ./config/config		/etc/kubernetes/config

sh ./services/kube-apiserver.sh
sh ./services/kube-controller-manager.sh
sh ./services/kube-scheduler.sh
sh ./services/kubelet.sh
sh ./services/kube-proxy.sh


echo "========= docker cleaning exited and dead contain ..."
sh ./clern.sh

