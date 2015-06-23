#!/bin/sh

K8S_KUBE_IMAGE='gcr.io/google_containers/hyperkube:v0.18.2'
K8S_ETCD_IMAGE='gcr.io/google_containers/etcd:2.0.12'
K8S_FLANNL_IMAGE='quay.io/coreos/flannel:0.4.1'
K8S_FLANNL_SUBNET_CONF=10.100.0.0/16

## stop per install k8s
systemctl stop apiserver
systemctl stop controller-manager
systemctl stop scheduler
systemctl stop etcd
systemctl disable apiserver
systemctl disable controller-manager
systemctl disable scheduler
systemctl disable etcd

## first run docker-bootstrap
sh ./docker-bootstrap.sh


## run etcd
sudo docker -H unix:///var/run/docker-bootstrap.sock run --net=host -d ${K8S_ETCD_IMAGE} /usr/local/bin/etcd --addr=127.0.0.1:4001 --bind-addr=0.0.0.0:4001 --data-dir=/var/etcd/data
sudo docker -H unix:///var/run/docker-bootstrap.sock run --net=host ${K8S_ETCD_IMAGE} etcdctl set /coreos.com/network/config '{ "Network": "${K8S_FLANNL_SUBNET_CONF}" }'


## init flannld subnet config
sudo docker -H unix:///var/run/docker-bootstrap.sock run --net=host -d --privileged -v /dev/net:/dev/net ${K8S_FLANNL_IMAGE}

flannl_image_id=`sudo docker ps |grep '${K8S_FLANNL_IMAGE}' | awk '{print $1}'`

sudo docker -H unix:///var/run/docker-bootstrap.sock exec ${flannl_image_id} cat /run/flannel/subnet.env > ${KUBE_FLANNEL_CONF}

## run docker main
sh ./docker-main.sh

## kubernetes master
sudo docker run --net=host -d -v /var/run/docker.sock:/var/run/docker.sock  ${K8S_KUBE_IMAGE} /hyperkube kubelet --api_servers=http://localhost:8080 --v=2 --address=0.0.0.0 --enable_server --hostname_override=127.0.0.1 --config=/etc/kubernetes/manifests-multi


## service proxy
sudo docker run --net=host -d --privileged ${K8S_KUBE_IMAGE} /hyperkube proxy --master=http://127.0.0.1:8080 --v=2