#!/bin/sh

redEcho() {
    [ -c /dev/stdout ] && {
        # if stdout is console, turn on color output.
        echo -ne "\033[1;31m"
        echo -n "$@"
        echo -e "\033[0m"
    } || echo "$@"
}

redEcho "========= docker cleaning exited and dead contain ..."
#docker ps -a | grep -E 'Exited|Dead' | awk '{print $1}'  | xargs --no-run-if-empty docker rm -f
docker ps -a | grep -v CONTAINER | awk '{print $1}' | xargs --no-run-if-empty docker inspect --format '{{ .Id }} {{ .State.Running }}' | grep  'false' | awk '{print $1}'  | xargs --no-run-if-empty docker rm -f

redEcho "========= docker clean images"
docker images | grep '<none>' | awk '{print $3}' | xargs --no-run-if-empty docker rmi -f