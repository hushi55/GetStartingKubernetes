#!/bin/sh

sh generate-jetty-deploy.sh ${project}
sh generate-dockerfile.sh ${project}
docker build -t kingdee/${branch}-${project}-${date}-${version} -f Dockerfile .

rm ./Dockerfile
