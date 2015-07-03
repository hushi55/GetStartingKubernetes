


#########################################################
########                dns           ###################
#########################################################


kubectl create -f dns/skydns-rc.yaml
kubectl create -f dns/skydns-svc.yaml

kubectl stop -f dns/skydns-rc.yaml
kubectl delete -f dns/skydns-svc.yaml



#########################################################
########            monitoring        ###################
#########################################################


kubectl create -f cluster-monitoring/influxdb/influxdb-grafana-controller.yaml
kubectl create -f cluster-monitoring/influxdb/grafana-service.yaml
kubectl create -f cluster-monitoring/influxdb/influxdb-service.yaml
kubectl create -f cluster-monitoring/influxdb/heapster-controller.yaml
kubectl create -f cluster-monitoring/influxdb/heapster-service.yaml

kubectl stop -f cluster-monitoring/influxdb/heapster-controller.yaml
kubectl delete -f cluster-monitoring/influxdb/heapster-service.yaml
kubectl stop -f cluster-monitoring/influxdb/influxdb-grafana-controller.yaml
kubectl delete -f cluster-monitoring/influxdb/grafana-service.yaml
kubectl delete -f cluster-monitoring/influxdb/influxdb-service.yaml



cat << EOF | kubectl create -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: heapster
EOF


#########################################################
########       fluentd-elasticsearch      ###############
#########################################################


kubectl create -f fluentd-elasticsearch/es-controller.yaml
kubectl create -f fluentd-elasticsearch/es-service.yaml
kubectl create -f fluentd-elasticsearch/kibana-controller.yaml
kubectl create -f fluentd-elasticsearch/kibana-service.yaml



kubectl stop -f fluentd-elasticsearch/es-controller.yaml
kubectl delete -f fluentd-elasticsearch/es-service.yaml
kubectl stop -f fluentd-elasticsearch/kibana-controller.yaml
kubectl delete -f fluentd-elasticsearch/kibana-service.yaml






#########################################################
########             guestbook        ###################
#########################################################


kubectl stop -f guestbook/redis-master-controller.json
kubectl stop -f guestbook/redis-slave-controller.json
kubectl stop -f guestbook/frontend-controller.json
kubectl delete -f guestbook/redis-master-service.json
kubectl delete -f guestbook/redis-slave-service.json
kubectl delete -f guestbook/frontend-service.json


kubectl create -f guestbook/redis-master-controller.json
kubectl create -f guestbook/redis-master-service.json
kubectl create -f guestbook/redis-slave-controller.json
kubectl create -f guestbook/redis-slave-service.json
kubectl create -f guestbook/frontend-controller.json
kubectl create -f guestbook/frontend-service.json















