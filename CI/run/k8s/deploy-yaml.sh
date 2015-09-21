#!/bin/sh


PROG=`basename $0`
BASE_DIR=`dirname $0`

usage() {
    cat <<EOF
Usage: ${PROG} [OPTION]...
generate app for k8s controller yaml file ro service file.
Example: ${PROG} -a microblog -b smoke -i 172.20.10.220:5000/kingdee/microblog-smoke

Options:
    -a, --app       			set the appcations. 
    -b, --branch    			set the git branch.
    -i, --image	    			set the k8s controller image.
    -s, --service        		boolean , flag generate k8s service yaml file.
    -m, --multivariate         	boolean , flag A/B test deploy.
    -n, --namespace         	set deploy to k8s's namespace.
    -h, --help      			display this help and exit
EOF
    exit $1
}

ARGS=`getopt -n "$PROG" -a -o a:b:i:s:m:n:h -l app:,branch:,image:,service:,multivariate:,namespace:,help -- "$@"`
[ $? -ne 0 ] && usage 1
eval set -- "${ARGS}"

while true; do
    case "$1" in
    -a|--app)
        app="$2"
        shift 2
        ;;
    -b|--branch)
        branch="$2"
        shift 2
        ;;
    -i|--image)
        image="$2"
        shift 2
        ;;
    -s|--service)
        svs_flag="$2"
        shift 2
        ;;
    -m|--multivariate)
        muti_flag="$2"
        shift 2
        ;;
    -n|--namespace)
        ns="$2"
        shift 2
        ;;
    -h|--help)
        usage
        ;;
    --)
        shift
        break
        ;;
    esac
done

redEcho() {
    [ -c /dev/stdout ] && {
        # if stdout is console, turn on color output.
        echo -ne "\033[1;31m"
        echo -n "$@"
        echo -e "\033[0m"
    } || echo "$@"
}


app=${app:-microblog}
branch=${branch:-smoke}
image=${image:-latest}
svs_flag=${svs_flag:-true}
muti_flag=${muti_flag:-false}
ns=${ns:-$branch}

if [[ $image == *":"* ]] ; then
  redEcho "image is ${image}"
else 
  image=`printf '172.20.10.220:5000/kingdee/%s/%s:%s' ${branch} ${app} ${image}`
  redEcho "built image is ${image}"
fi


### generate file to uuid dir, save yaml file to dir
uuid=`date +%s`_${RANDOM}_$$
tmp_dir=/home/docker_k8s/${ns}
mkdir -p /home/docker_k8s/${ns}

#### clean
#cleanupWhenExit() {
#    rm -rf /tmp/k8s/${uuid} &> /dev/null
#}
#trap "cleanupWhenExit" EXIT


##### generante service yaml file

namespace=kingdee-${ns}
if ${muti_flag};then 
	namespace=kingdee-${ns}-ab
	sh ${BASE_DIR}/generante-service-ab.sh ${app} ${branch} ${image} ${svs_flag} ${tmp_dir} ${namespace}
else
	sh ${BASE_DIR}/generante-service.sh ${app} ${branch} ${image} ${svs_flag} ${tmp_dir} ${namespace}
fi

############### run: deploy to k8s
redEcho "deploy ${image} to k8s"

redEcho "command : kubectl --namespace=${namespace} describe pods ${app} "
kubectl --namespace=${namespace} describe pods ${app}  >/dev/null

if [ $? -ne 0 ] ; then ## if not exist, create

	redEcho "k8s create pods with yaml file"

	kubectl create -f ${tmp_dir}/${app}-controller.yaml
	
	if [ $? -ne 0 ] ; then ## if create fail, stop rc and delete service
		break
	fi
	
	kubectl create -f ${tmp_dir}/${app}-service.yaml

	if [ $? -ne 0 ] ; then ## if create fail, stop rc and delete service
		kubectl stop   -f  ${tmp_dir}/${app}-controller.yaml
		kubectl delete -f  ${tmp_dir}/${app}-service.yaml
	fi

else   ### rolling-update

	redEcho "k8s rolling update"
	kubectl --namespace=${namespace} rolling-update  ${app}-v1 --image=${image}
	
fi     #ifend



