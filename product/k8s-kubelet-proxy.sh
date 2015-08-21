#!/bin/sh

K8S_KUBE_IMAGE='gcr.io/google_containers/hyperkube:v1.0.3'

KUBE_ETCD_SERVERS=http://192.168.1.237:2379
KUBE_API_ADDRESS=0.0.0.0
KUBE_API_PORT=8080
KUBE_ALLOW_PRIV=true
KUBE_LOG_DIR=/kingdee/kubernetes/logs
KUBE_LOGTOSTDERR=true
KUBE_LOG_LEVEL=0
KUBE_MASTER=172.20.10.221:8080
KUBE_LISTEN_ADDRESS=0.0.0.0
KUBE_CLUSTER_DNS=10.100.100.100
KUBE_CLUSTER_DOMAIN=k8s.cluster.local

KUBE_STATIC_POD_DIR_CONF=/etc/kubelet.d

KUBE_HEAPSTER_CADVISOR_HOSTFILE=/etc/heapster.d

			
echo "========= static pods config "
mkdir -p ${KUBE_STATIC_POD_DIR_CONF}
cp ./k8s-static-nodes/* ${KUBE_STATIC_POD_DIR_CONF}

echo "========= static heapster config "
mkdir -p ${KUBE_HEAPSTER_CADVISOR_HOSTFILE}
cp ./images/heapster/hosts.json ${KUBE_HEAPSTER_CADVISOR_HOSTFILE}

echo "========= installing docker-main kubernetes minoins ..."
## kubernetes master
sudo docker run --net=host -d \
		--privileged=true \
		--volume=${KUBE_STATIC_POD_DIR_CONF}:${KUBE_STATIC_POD_DIR_CONF}:ro \
		-v /var/run/docker.sock:/var/run/docker.sock \
		${K8S_KUBE_IMAGE} \
				/hyperkube kubelet \
						--logtostderr=${KUBE_LOGTOSTDERR} \
					    --v=${KUBE_LOG_LEVEL} \
					    --address=${KUBE_LISTEN_ADDRESS} \
						--api-servers=${KUBE_MASTER} \
						--cluster_dns=${KUBE_CLUSTER_DNS} \
						--cluster_domain=${KUBE_CLUSTER_DOMAIN} \
						--config="${KUBE_STATIC_POD_DIR_CONF}" \
					    --allow-privileged=${KUBE_ALLOW_PRIV}
					    
sudo docker run --net=host -d \
		--privileged=true  \
		-v /var/run/docker.sock:/var/run/docker.sock \
		${K8S_KUBE_IMAGE} \
				/hyperkube proxy \
						--logtostderr=${KUBE_LOGTOSTDERR} \
					    --v=${KUBE_LOG_LEVEL} \
					    --bind-address=${KUBE_LISTEN_ADDRESS} \
					    --master=${KUBE_MASTER} 

