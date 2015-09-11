

docker run -d -p 5002:5000  -v /kingdee/docker/registry/images/:/var/lib/registry registry:2

docker run -d -p 5000:5000 --restart=always -v /kingdee/docker/registry/images/:/var/lib/registry registry:2
docker run -d -p 5000:5000 --restart=always -v /kingdee/docker/registry/images/:/var/lib/registry registry-1.docker.io/distribution/registry:2.1
docker run -d -p 5000:5000 --restart=always registry:2
docker run -d -p 5000:5000 --restart=always --name registry registry:2
docker run -d -p 5000:5000 --restart=always distribution/registry:2.1.1

docker run -p 8081:8080 mlabouardy/registry-ui:latest

docker run -d -p 8081:8080 --restart=always -e REG1=http://172.20.10.220:5000/v2/ atcol/docker-registry-ui:v2

docker run -d --restart=always  --privileged=true --net=host index.alauda.cn/georce/router
docker run -d -p 8080:8080 --restart=always -e REG1=http://172.20.10.220:5000/v2/ atcol/docker-registry-ui
docker run -d -p 9087:80 --restart=always -e ENV_DOCKER_REGISTRY_HOST=172.20.10.220 -e ENV_DOCKER_REGISTRY_PORT=5000 konradkleine/docker-registry-frontend


##### Git hub
https://github.com/Takayoshi-Aoyagi/kuzilla

docker run -i -t -p 8080:8080 -e REGISTRY_HOST=172.20.10.220 -e REGISTRY_PORT=5000 hyper/docker-registry-web

docker run -d \
-p 9089:80 \
--restart=always \
-e ENV_DOCKER_REGISTRY_HOST=172.20.10.220 \
-e ENV_DOCKER_REGISTRY_PORT=5000 \
-e ENV_MODE_BROWSE_ONLY=true \
konrandleine/docker-registry-frontend:v2.0.1

##################################################
###############	 web UI 	    		###########
##################################################

https://github.com/mkuchin/docker-registry-web.git

docker run -d \
--restart=always \
-p 5050:8080 \
-e REGISTRY_HOST=172.20.10.220 \
-e REGISTRY_PORT=5000 \
hyper/docker-registry-web

##################################################
###############	registry 2.0    		###########
##################################################
docker run -d -p 5000:5000 \
--restart=always \
-v /home/registry/:/var/lib/registry \
registry:2
 

mkdir -p certs && openssl req \
  -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key \
  -x509 -days 3650 -out certs/domain.crt

##############################
### rolling-update
##############################

// Update pods of frontend-v1 using new replication controller data in frontend-v2.json.
$ kubectl rolling-update frontend-v1 -f frontend-v2.json

// Update pods of frontend-v1 using JSON data passed into stdin.
$ cat frontend-v2.json | kubectl rolling-update frontend-v1 -f -

// Update the pods of frontend-v1 to frontend-v2 by just changing the image, and switching the
// name of the replication controller.
$ kubectl rolling-update frontend-v1 frontend-v2 --image=image:v2

// Update the pods of frontend by just changing the image, and keeping the old name
$ kubectl rolling-update frontend --image=image:v2