#!bin/sh

## dir mk
KUBE_LOG_DIR=/kingdee/kubernetes/logs

mkdir -p ${KUBE_LOG_DIR}

echo "installing flanneld service ..."
sh ./flanneld.sh

echo "installing docker service ..."
sh ./docker-flannel.sh

echo "installing kubelet service ..."
sh ./kubelet.sh

echo "installing proxy service ..."
sh ./proxy.sh