#!/bin/sh

K8S_KUBE_IMAGE='gcr.io/google_containers/hyperkube:v0.21.2'

KUBE_ETCD_SERVERS=http://172.20.10.221:4001
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

# echo "========= runing cadvisor "
# docker inspect cadvisor >/dev/null 2>&1 && docker rm -f cadvisor || true
# docker run -d \
# 			--publish=4194:8080 \
# 			--name=cadvisor \
# 			--volume=/var/run:/var/run:rw \
# 			--volume=/sys/fs/cgroup/:/sys/fs/cgroup:ro \
# 			--volume=/var/lib/docker/:/var/lib/docker:ro \
# 			google/cadvisor:latest

#echo "========= installing packetbeat to all nodes ..."
#docker run --net=host -d \
#		-v /var/log:/var/log/packetbeat \
#		packetbeat packetbeat -e -c /etc/packetbeat/packetbeat.yml

			
echo "========= static pods config "
mkdir -p ${KUBE_STATIC_POD_DIR_CONF}
cp ../k8s-kubelet-conf/* ${KUBE_STATIC_POD_DIR_CONF}

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

