
kubectl --namespace='kingdee-hushikssp12121212' delete rc,pods,services --all

etcdctl -C 192.168.1.237:2379 rm --recursive /kingdee/git/${branch}

#rm -f /kingdee/confd/conf/{conf.d,templates}/${branch}*
#rm -f /usr/local/nginx/conf/conf.d/server/${branch}*

## delete images
docker images| grep "${branch}" | awk '{printf  $1 ":" $2 "\n"}' | xargs --no-run-if-empty  docker rmi -f 