#!/bin/sh

## enable ip forward
sysctl -w net.ipv4.ip_forward=1

K8S_MASTER_IP=172.20.10.221
K8S_KUBE_IMAGE='gcr.io/google_containers/hyperkube:v0.21.2'
K8S_FLANNL_IMAGE='quay.io/coreos/flannel:0.4.1'
K8S_FLANNL_CONF_FILE=/kingdee/kubernetes/bin/flanneld-subnet.env


echo "========= yum installing soft ..."
yum install -y zip unzip bzip2 tar gzip


echo "========= stoping per install k8s ..."
## stop per install k8s
systemctl stop flanneld
systemctl stop docker-bootstrap.socket
systemctl stop docker-bootstrap.service
systemctl stop docker.service
systemctl stop docker.socket
systemctl stop docker
systemctl stop kubelet
systemctl stop proxy

systemctl disable flanneld
systemctl disable docker-bootstrap.socket
systemctl disable docker-bootstrap.service
systemctl disable docker.service
systemctl disable docker.socket
systemctl disable docker
systemctl disable kubelet
systemctl disable proxy


## docker 1.7 devicemapper have same problems
#echo "========= installing last version docker ..."
## install new version docker 
#cp /root/docker /usr/bin/
#chmod +x /usr/bin/docker


echo "========= installing docker-bootstrap ..."
## first run docker-bootstrap
sh ./docker-bootstrap.sh


#echo "========= loading docker-bootstrap images ..."
## load images
#gzip -d /root/gcr.io.tar.gz
#docker -H unix:///var/run/docker-bootstrap.sock load -i /root/gcr.io.tar
#docker -H unix:///var/run/docker-bootstrap.sock load -i /root/flannl-imgae.tar


echo "========= installing docker-bootstrap images flannel ..."
## run flannel
sudo docker -H unix:///var/run/docker-bootstrap.sock run -d --net=host --privileged -v /dev/net:/dev/net ${K8S_FLANNL_IMAGE} /opt/bin/flanneld --etcd-endpoints=http://${K8S_MASTER_IP}:4001

flannl_image_id=`sudo docker -H unix:///var/run/docker-bootstrap.sock ps |grep ${K8S_FLANNL_IMAGE} | awk '{print $1}'`
echo "========= flannl contain id : " ${flannl_image_id}

sudo docker -H unix:///var/run/docker-bootstrap.sock exec ${flannl_image_id} cat /run/flannel/subnet.env > ${K8S_FLANNL_CONF_FILE}


echo "========= installing docker-main ..."
## run docker main
sh ./docker-main.sh


echo "========= installing docker-main kubernetes kubelet and proxy ..."

sh ./k8s-kubelet-proxy.sh 

#sudo docker run --net=host -d -v /var/run/docker.sock:/var/run/docker.sock  ${K8S_KUBE_IMAGE} /hyperkube kubelet --api_servers=http://${K8S_MASTER_IP}:8080 --v=2 --address=0.0.0.0 --enable_server --hostname_override=$(hostname -i)
#sudo docker run --net=host -d --privileged ${K8S_KUBE_IMAGE} /hyperkube proxy --master=http://${K8S_MASTER_IP}:8080 --v=2