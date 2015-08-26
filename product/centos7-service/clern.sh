#!/bin/sh


echo "========= docker cleaning exited and dead contain ..."
docker ps -a | grep -E 'Exited|Dead' | awk '{print $1}'  | xargs --no-run-if-empty docker rm -f


echo "========= cleaning kubernetes soft links ..."
yum install -y symlinks
symlinks -d /var/log/containers