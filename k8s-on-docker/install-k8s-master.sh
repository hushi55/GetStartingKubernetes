#!/bin/sh

## enable ip forward
sysctl -w net.ipv4.ip_forward=1

K8S_KUBE_IMAGE='gcr.io/google_containers/hyperkube:v0.21.2'
K8S_ETCD_IMAGE='gcr.io/google_containers/etcd:2.0.12'
K8S_FLANNL_IMAGE='quay.io/coreos/flannel:0.5.1'
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


echo "========= installing docker-bootstrap ..."
#rm  -rf /var/lib/docker-bootstrap
## first run docker-bootstrap
sh ./docker-bootstrap.sh

echo "========= installing docker-bootstrap etcd ..."
## run etcd
sudo docker -H unix:///var/run/docker-bootstrap.sock run --net=host -d ${K8S_ETCD_IMAGE} /usr/local/bin/etcd --listen-client-urls 'http://0.0.0.0:2379,http://0.0.0.0:4001' --advertise-client-urls 'http://0.0.0.0:2379,http://0.0.0.0:4001' --listen-peer-urls 'http://0.0.0.0:2380,http://0.0.0.0:7001' --data-dir /var/etcd/data

etcd_image_id=`sudo docker -H unix:///var/run/docker-bootstrap.sock ps |grep ${K8S_ETCD_IMAGE} | awk '{print $1}'`

echo "waiting for etcd to become available..."
sleep 5;

echo "========= etcd contain id :" ${etcd_image_id}
flannl_subnet=`printf "{\"Network\":\"%s\"}" "$K8S_FLANNL_SUBNET_CONF"`
echo "========= flannl_subnet :" ${flannl_subnet}
sudo docker -H unix:///var/run/docker-bootstrap.sock exec ${etcd_image_id} etcdctl set /coreos.com/network/config ${flannl_subnet}

echo "========= installing docker-bootstrap flannld ..."
## init flannld subnet config
sudo docker -H unix:///var/run/docker-bootstrap.sock run --net=host -d --privileged -v /dev/net:/dev/net ${K8S_FLANNL_IMAGE}

flannl_image_id=`sudo docker -H unix:///var/run/docker-bootstrap.sock ps |grep ${K8S_FLANNL_IMAGE} | awk '{print $1}'`
echo "========= flannl contain id :" ${flannl_image_id}

sudo docker -H unix:///var/run/docker-bootstrap.sock exec ${flannl_image_id} cat /run/flannel/subnet.env > ${K8S_FLANNL_CONF_FILE}


echo "========= installing docker-main ..."
sh ./docker-main.sh



echo "========= installing docker-main kubernetes master ..."
sh ./k8s-api-server.sh 
sh ./k8s-kubelet-proxy.sh 


