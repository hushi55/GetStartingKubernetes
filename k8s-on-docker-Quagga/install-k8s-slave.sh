#!/bin/sh

## enable ip forward
sysctl -w net.ipv4.ip_forward=1

K8S_MASTER_IP=172.20.10.221
K8S_KUBE_IMAGE='gcr.io/google_containers/hyperkube:v0.20.2'
K8S_FLANNL_IMAGE='quay.io/coreos/flannel:0.4.1'
K8S_FLANNL_CONF_FILE=/kingdee/kubernetes/bin/flanneld-subnet.env


echo "========= yum installing soft ..."
yum install -y zip unzip bzip2 tar gzip


echo "========= stoping per install k8s ..."
## stop per install k8s
systemctl stop flanneld
systemctl stop docker-bootstrap.socket
systemctl stop docker-bootstrap.service
systemctl stop docker.socket
systemctl stop docker.service
systemctl stop docker
systemctl stop kubelet
systemctl stop proxy

systemctl disable flanneld
systemctl disable docker-bootstrap.socket
systemctl disable docker-bootstrap.service
systemctl disable docker.socket
systemctl disable docker.service
systemctl disable docker
systemctl disable kubelet
systemctl disable proxy


echo "========= installing docker-main ..."
## run docker main
sh ./docker-main.sh

echo "========= installing Quagga ..."
docker run -d  --privileged=true --net=host index.alauda.cn/georce/router
#docker run -d  --privileged=true --net=host  osrg/quagga

echo "========= installing docker-main kubernetes kubelet and proxy ..."

sh ./k8s-kubelet-proxy.sh 

#sudo docker run --net=host -d -v /var/run/docker.sock:/var/run/docker.sock  ${K8S_KUBE_IMAGE} /hyperkube kubelet --api_servers=http://${K8S_MASTER_IP}:8080 --v=2 --address=0.0.0.0 --enable_server --hostname_override=$(hostname -i)
#sudo docker run --net=host -d --privileged ${K8S_KUBE_IMAGE} /hyperkube proxy --master=http://${K8S_MASTER_IP}:8080 --v=2