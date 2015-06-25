


#########################################################
########                dns           ###################
#########################################################


kubectl create -f skydns-rc.yaml.in
kubectl create -f skydns-svc.yaml.in

kubectl stop -f skydns-rc.yaml.in
kubectl delete -f skydns-svc.yaml.in



#########################################################
########            monitoring        ###################
#########################################################

kubectl create -f es-controller.yaml
kubectl create -f es-service.yaml
kubectl create -f kibana-controller.yaml
kubectl create -f kibana-service.yaml
kubectl create -f heapster-controller.yaml
kubectl create -f heapster-service.yaml

kubectl stop -f es-controller.yaml
kubectl delete -f es-service.yaml
kubectl stop -f kibana-controller.yaml
kubectl delete -f kibana-service.yaml
kubectl stop -f heapster-controller.yaml
kubectl delete -f heapster-service.yaml




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















