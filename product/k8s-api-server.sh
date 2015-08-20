#!/bin/sh

K8S_KUBE_IMAGE='gcr.io/google_containers/hyperkube:v1.0.3'
K8S_FLANNL_SUBNET_CONF=10.100.0.0/16

KUBE_ETCD_SERVERS=http://192.168.1.237:2379
KUBE_API_PORT=8080
KUBE_ALLOW_PRIV=true
KUBE_LOG_DIR=/kingdee/kubernetes/logs
KUBE_LOGTOSTDERR=true
KUBE_LOG_LEVEL=0
KUBE_MASTER=172.20.10.221:8080
KUBE_LISTEN_ADDRESS=0.0.0.0

function set_service_accounts {
    SERVICE_ACCOUNT_LOOKUP=${SERVICE_ACCOUNT_LOOKUP:-false}
    SERVICE_ACCOUNT_KEY=${SERVICE_ACCOUNT_KEY:-"/tmp/kube-serviceaccount.key"}
    # Generate ServiceAccount key if needed
    if [[ ! -f "${SERVICE_ACCOUNT_KEY}" ]]; then
      mkdir -p "$(dirname ${SERVICE_ACCOUNT_KEY})"
      openssl genrsa -out "${SERVICE_ACCOUNT_KEY}" 2048 2>/dev/null
    fi
}

#set_service_accounts

echo "========= static pods config "
mkdir -p ${KUBE_STATIC_POD_DIR_CONF}
cp ./k8s-static-nodes/* ${KUBE_STATIC_POD_DIR_CONF}

echo "========= installing docker-main kubernetes master ..."

touch /var/log/kube-scheduler.log
touch /var/log/kube-controller-manager.log
touch /var/log/kube-apiserver.log

## kubernetes master
sudo docker run --net=host -d \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /var/log/kube-apiserver.log:/var/log/kube-apiserver.log \
		${K8S_KUBE_IMAGE} \
				/hyperkube apiserver \
							--v=${KUBE_LOG_LEVEL} \
							--logtostderr=${KUBE_LOGTOSTDERR}  \
							--etcd-servers=${KUBE_ETCD_SERVERS} \
							--insecure-bind-address=${KUBE_LISTEN_ADDRESS} \
							--insecure-port=${KUBE_API_PORT} \
							--allow-privileged=${KUBE_ALLOW_PRIV} \
							--service-cluster-ip-range=${K8S_FLANNL_SUBNET_CONF} \
							1>>/var/log/kube-apiserver.log 2>&1

sudo docker run --net=host -d \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /var/log/kube-controller-manager.log:/var/log/kube-controller-manager.log \
		${K8S_KUBE_IMAGE} \
				/hyperkube controller-manager \
							--logtostderr=${KUBE_LOGTOSTDERR} \
							--address=${KUBE_LISTEN_ADDRESS} \
						    --v=${KUBE_LOG_LEVEL} \
							--master=${KUBE_MASTER} \
							1>>/var/log/kube-controller-manager.log 2>&1
						    
						    
sudo docker run --net=host -d \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /var/log/kube-scheduler.log:/var/log/kube-scheduler.log \
		${K8S_KUBE_IMAGE} \
				/hyperkube scheduler \
							--logtostderr=${KUBE_LOGTOSTDERR} \
						    --v=${KUBE_LOG_LEVEL} \
							--address=${KUBE_LISTEN_ADDRESS} \
							--master=${KUBE_MASTER} \
							1>>/var/log/kube-scheduler.log 2>&1

