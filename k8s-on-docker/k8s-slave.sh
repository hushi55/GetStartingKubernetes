#!/bin/sh

K8S_MASTER_IP=172.20.10.221
K8S_KUBE_IMAGE=gcr.io/google_containers/hyperkube:v0.18.2
K8S_FLANNL_IMAGE=quay.io/coreos/flannel:0.4.1

## stop per install k8s
systemctl stop flanneld.service
systemctl stop docker.socket
systemctl stop docker.service
systemctl stop kubelet.service
systemctl stop proxy.service

systemctl disable flanneld.service
systemctl disable docker.socket
systemctl disable docker.service
systemctl disable kubelet.service
systemctl disable proxy.service

## first run docker-bootstrap
sh ./docker-bootstrap.sh

## run flannel
sudo docker -H unix:///var/run/docker-bootstrap.sock run -d --net=host --privileged -v /dev/net:/dev/net ${K8S_FLANNL_IMAGE} /opt/bin/flanneld --etcd-endpoints=http://${K8S_MASTER_IP}:4001

flannl_image_id=`sudo docker ps |grep '${K8S_FLANNL_IMAGE}' | awk '{print $1}'`

sudo docker -H unix:///var/run/docker-bootstrap.sock exec ${flannl_image_id} cat /run/flannel/subnet.env

## run docker main
sh ./docker-main.sh

sudo docker run --net=host -d -v /var/run/docker.sock:/var/run/docker.sock  ${K8S_KUBE_IMAGE} /hyperkube kubelet --api_servers=http://${K8S_MASTER_IP}:8080 --v=2 --address=0.0.0.0 --enable_server --hostname_override=$(hostname -i)
sudo docker run --net=host -d --privileged ${K8S_KUBE_IMAGE} /hyperkube proxy --master=http://${K8S_MASTER_IP}:8080 --v=2