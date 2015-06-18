#!/bin/sh

# pull request docker images
docker pull kubernetes/redis-slave:v2
docker pull kubernetes/example-guestbook-php-redis:v2
docker pull redis
docker load -i gcr-pause.tar.gz