





kubectl create -f skydns-rc.yaml.in
kubectl create -f skydns-svc.yaml.in

kubectl stop -f skydns-rc.yaml.in
kubectl delete -f skydns-svc.yaml.in





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