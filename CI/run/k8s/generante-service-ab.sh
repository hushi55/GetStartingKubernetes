#!/bin/sh

app=${1}
branch=${2}
image=${3}
svs_flag=${4}
tmp_dir=${5}

redEcho() {
    [ -c /dev/stdout ] && {
        # if stdout is console, turn on color output.
        echo -ne "\033[1;31m"
        echo -n "$@"
        echo -e "\033[0m"
    } || echo "$@"
}


cat <<EOF >${tmp_dir}/${app}-controller.yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: ${app}-v1
  namespace: kingdee-${branch}-ab
  labels:
    k8s-app: ${app}
    version: v1
spec:
  replicas: 1
  selector:
    k8s-app: ${app}
    version: v1
  template:
    metadata:
      labels:
        k8s-app: ${app}
        version: v1
    spec:
      containers:
        - image: ${image}
          name: ${app}
          # defines the health checking
          livenessProbe:
              # an http probe
              httpGet:
                 path: /${app}/ping.html
                 port: 10091
              # length of time to wait for a pod to initialize
              # after pod startup, before applying health checking
              initialDelaySeconds: 300
              timeoutSeconds: 2   
EOF

redEcho "generated ${app}-controller.yaml"

if ${svs_flag};then 
cat <<EOF >${tmp_dir}/${app}-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: ${app}-${branch}
  namespace: kingdee-${branch}-ab
  labels: 
    kingdee/${app}-${branch}: "true"
    kingdee/name: "${app}-${branch}"
spec: 
  ports: 
    - port: 80
      targetPort: 10091
  selector: 
    k8s-app: ${app}
EOF

redEcho "generated ${app}-service.yaml"

fi
