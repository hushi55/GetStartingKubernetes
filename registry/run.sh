

docker run -d -p 5000:5000  -v /kingdee/docker/registry/images/:/var/lib/registry registry:2

docker run -d -p 5000:5000 --restart=always -v /kingdee/docker/registry/images/:/var/lib/registry registry:2
docker run -d -p 5000:5000 --restart=always registry:2
docker run -d -p 5000:5000 --restart=always --name registry registry:2



docker run -d --restart=always  --privileged=true --net=host index.alauda.cn/georce/router
docker run -d -p 8080:8080 --restart=always atcol/docker-registry-ui
docker run -d -p 9087:80 --restart=always -e ENV_DOCKER_REGISTRY_HOST=172.20.10.220 -e ENV_DOCKER_REGISTRY_PORT=5000 konradkleine/docker-registry-frontend
docker run -d -p 9088:80 --restart=always -e ENV_DOCKER_REGISTRY_HOST=172.20.10.220 -e ENV_DOCKER_REGISTRY_PORT=5000 konradkleine/docker-registry-frontend:v2
