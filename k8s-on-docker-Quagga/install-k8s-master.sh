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
sh ./docker-main.sh

## run etcd
sudo docker run --net=host -d ${K8S_ETCD_IMAGE} /usr/local/bin/etcd --listen-client-urls 'http://0.0.0.0:2379,http://0.0.0.0:4001' --advertise-client-urls 'http://0.0.0.0:2379,http://0.0.0.0:4001' --listen-peer-urls 'http://0.0.0.0:2380,http://0.0.0.0:7001' --data-dir /var/etcd/data
echo "waiting for etcd to become available..."
sleep 5;


#echo "========= installing Quagga ..."
#docker run -d --privileged=true --net=host index.alauda.cn/georce/router
#docker run -d  --privileged=true --net=host  osrg/quagga

echo "========= installing docker-main kubernetes master ..."
sh ./k8s-api-server.sh 
sh ./k8s-kubelet-proxy.sh

