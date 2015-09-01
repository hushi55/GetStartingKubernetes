#!/bin/sh


echo "========= docker cleaning exited and dead contain ..."
#docker ps -a | grep -E 'Exited|Dead' | awk '{print $1}'  | xargs --no-run-if-empty docker rm -f
docker ps -a | grep -v CONTAINER | awk '{print $1}' | xargs --no-run-if-empty docker inspect --format '{{ .Id }} {{ .State.Running }}' | grep  'false' | awk '{print $1}'  | xargs --no-run-if-empty docker rm -f

echo "========= docker clean images"
docker images | grep '<none>' | awk '{print $3}' | xargs --no-run-if-empty docker rmi -f



echo "========= cleaning kubernetes soft links ..."
yum install -y symlinks
symlinks -d /var/log/containers