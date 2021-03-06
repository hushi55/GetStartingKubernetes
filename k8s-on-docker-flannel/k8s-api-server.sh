#!/bin/sh

K8S_KUBE_IMAGE='gcr.io/google_containers/hyperkube:v0.21.2'
K8S_FLANNL_SUBNET_CONF=10.100.0.0/16

KUBE_ETCD_SERVERS=http://172.20.10.221:4001
KUBE_API_PORT=8080
KUBE_ALLOW_PRIV=true
KUBE_LOG_DIR=/kingdee/kubernetes/logs
KUBE_LOGTOSTDERR=true
KUBE_LOG_LEVEL=0
KUBE_MASTER=172.20.10.221:8080
KUBE_LISTEN_ADDRESS=0.0.0.0

echo "========= installing docker-main kubernetes master ..."
## kubernetes master
sudo docker run --net=host -d \
		-v /var/run/docker.sock:/var/run/docker.sock \
		${K8S_KUBE_IMAGE} \
				/hyperkube apiserver \
							--v=${KUBE_LOG_LEVEL} \
							--logtostderr=${KUBE_LOGTOSTDERR}  \
							--etcd-servers=${KUBE_ETCD_SERVERS} \
							--insecure-bind-address=${KUBE_LISTEN_ADDRESS} \
							--insecure-port=${KUBE_API_PORT} \
							--allow-privileged=${KUBE_ALLOW_PRIV} \
							--service-cluster-ip-range=${K8S_FLANNL_SUBNET_CONF}

sudo docker run --net=host -d \
		-v /var/run/docker.sock:/var/run/docker.sock \
		${K8S_KUBE_IMAGE} \
				/hyperkube controller-manager \
							--logtostderr=${KUBE_LOGTOSTDERR} \
							--address=${KUBE_LISTEN_ADDRESS} \
						    --v=${KUBE_LOG_LEVEL} \
						    --master=${KUBE_MASTER}
						    
sudo docker run --net=host -d \
		-v /var/run/docker.sock:/var/run/docker.sock \
		${K8S_KUBE_IMAGE} \
				/hyperkube scheduler \
							--logtostderr=${KUBE_LOGTOSTDERR} \
						    --v=${KUBE_LOG_LEVEL} \
							--address=${KUBE_LISTEN_ADDRESS} \
						    --master=${KUBE_MASTER}

