#!/bin/sh

## enable ip forward
sysctl -w net.ipv4.ip_forward=1

K8S_KUBE_IMAGE='gcr.io/google_containers/hyperkube:v0.18.2'
K8S_ETCD_IMAGE='gcr.io/google_containers/etcd:2.0.12'
K8S_FLANNL_IMAGE='quay.io/coreos/flannel:0.4.1'
K8S_FLANNL_SUBNET_CONF=10.100.0.0/16
K8S_FLANNL_CONF_FILE=/kingdee/kubernetes/bin/flanneld-subnet.env

yum install -y zip unzip bzip2 tar gzip

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

## first run docker-bootstrap
sh ./docker-bootstrap.sh

## load images
gzip -d /root/gcr.io.tar.gz
docker -H unix:///var/run/docker-bootstrap.sock load -i /root/gcr.io.tar
docker -H unix:///var/run/docker-bootstrap.sock load -i /root/flannl-imgae.tar


## run etcd
sudo docker -H unix:///var/run/docker-bootstrap.sock run --net=host -d ${K8S_ETCD_IMAGE} /usr/local/bin/etcd --addr=127.0.0.1:4001 --bind-addr=0.0.0.0:4001 --data-dir=/var/etcd/data
sudo docker -H unix:///var/run/docker-bootstrap.sock run --net=host ${K8S_ETCD_IMAGE} etcdctl set /coreos.com/network/config '{ "Network": "${K8S_FLANNL_SUBNET_CONF}" }'


## init flannld subnet config
sudo docker -H unix:///var/run/docker-bootstrap.sock run --net=host -d --privileged -v /dev/net:/dev/net ${K8S_FLANNL_IMAGE}

flannl_image_id=`sudo docker ps |grep '${K8S_FLANNL_IMAGE}' | awk '{print $1}'`

sudo docker -H unix:///var/run/docker-bootstrap.sock exec ${flannl_image_id} cat /run/flannel/subnet.env > ${K8S_FLANNL_CONF_FILE}

## run docker main
sh ./docker-main.sh

## load images
docker load -i /root/gcr.io.tar
docker load -i /root/flannl-imgae.tar

## kubernetes master
sudo docker run --net=host -d -v /var/run/docker.sock:/var/run/docker.sock  ${K8S_KUBE_IMAGE} /hyperkube kubelet --api_servers=http://localhost:8080 --v=2 --address=0.0.0.0 --enable_server --hostname_override=127.0.0.1 --config=/etc/kubernetes/manifests-multi


## service proxy
sudo docker run --net=host -d --privileged ${K8S_KUBE_IMAGE} /hyperkube proxy --master=http://127.0.0.1:8080 --v=2