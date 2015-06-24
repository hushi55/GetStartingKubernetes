#!/bin/sh

K8S_KUBE_IMAGE='gcr.io/google_containers/hyperkube:v0.18.2'

KUBE_ETCD_SERVERS=http://172.20.10.221:4001
KUBE_API_ADDRESS=0.0.0.0
KUBE_API_PORT=8080
KUBE_ALLOW_PRIV=false
KUBE_LOG_DIR=/kingdee/kubernetes/logs
KUBE_LOGTOSTDERR=false
KUBE_LOG_LEVEL=0
KUBE_MASTER=172.20.10.221:8080
KUBE_ADDRESS=0.0.0.0

echo "========= installing docker-main kubernetes minoins ..."
## kubernetes master
sudo docker run --net=host -d \
		-v /var/run/docker.sock:/var/run/docker.sock \
		${K8S_KUBE_IMAGE} \
				/hyperkube kubelet \
						--logtostderr=${KUBE_LOGTOSTDERR} \
					    --v=${KUBE_LOG_LEVEL} \
					    --log-dir=${KUBE_LOG_DIR} \
					    --address=${KUBE_MASTER} \
						--api-servers=${KUBE_MASTER} \
					    --allow-privileged=${KUBE_ALLOW_PRIV}
					    
sudo docker run --net=host -d \
		-v /var/run/docker.sock:/var/run/docker.sock \
		${K8S_KUBE_IMAGE} \
				/hyperkube proxy \
						--logtostderr=${KUBE_LOGTOSTDERR} \
					    --log-dir=${KUBE_LOG_DIR} \
					    --v=${KUBE_LOG_LEVEL} \
					    --bind-address=${KUBE_BIND_ADDRESS} \
					    --master=${KUBE_MASTER} 

