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
    -n, --namespace         	set deploy to k8s's namespace.
    -d, --depends         		set depends apps.
    -h, --help      			display this help and exit
EOF
    exit $1
}

ARGS=`getopt -n "$PROG" -a -o a:b:n:d:h -l app:,branch:,namespace:,depends:,help -- "$@"`
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
    -d|--depends)
        deployapps="$2"
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
ns=${ns:-$branch}

if [ ! -f "/tmp/listJar.txt" ]; then
	curl -GET http://192.168.1.50:8098/dkr/scripts/listJar.txt -o /tmp/listJar.txt
fi

declare -A GIT_JARS
while read line;do
	if [ "33sms"x = "$line"x ]; then
		continue
	fi
	_app=`sed "s/\./_/g" <<< $line`
	GIT_JARS[${_app}]=1
done < /tmp/listJar.txt


jars=" "
wars=" "

### set parents branch
key=`printf "/kingdee/git/%s/parentbranch" ${ns}`
etcdctl -C 192.168.1.237:2379 set ${key} "${branch}"


key_jars=`printf "/kingdee/git/%s/jars" ${ns}`
old_jars=`etcdctl -C 192.168.1.237:2379 get ${key_jars}`

key_wars=`printf "/kingdee/git/%s/wars" ${ns}`
old_wars=`etcdctl -C 192.168.1.237:2379 get ${key_wars}`

redEcho "old jars : " ${old_jars}
redEcho "old wars : " ${old_wars}

for _app in ${app} 
do
	_a=`sed "s/\./_/g" <<< ${_app}`
	if [ "33sms"x = "${_app}"x ] || [ "${GIT_JARS[${_a}]}" ]; then
		
		redEcho "wars is :" ${_a} 
		redEcho "wars is :" ${_app} 
		
		j_result=$(echo ${old_jars} | grep "${_app}")
		if [[ "$j_result"x = ""x ]]; then
		    old_jars=`echo ${old_jars} " " ${_app}`
		fi	
		
	else
	
		redEcho "wars is :"
		w_result=$(echo ${old_wars} | grep "${_app}")
		if [[ "$w_result"x = ""x ]]; then
		    old_wars=`echo ${old_wars} " " ${_app}`
		fi		
				
	fi
done

etcdctl -C 192.168.1.237:2379 set ${key_jars} "${old_jars}"
etcdctl -C 192.168.1.237:2379 set ${key_wars} "${old_wars}"


# set deploy apps
key_apps=`printf "/kingdee/git/%s/deployapps" ${ns}`
old_apps=`etcdctl -C 192.168.1.237:2379 get ${key_apps}`
if [ ${#deployapps[@]} > 0 ]; then
	
	if [ ${#deployapps[@]} > 0 ]; then 
		for a in ${deployapps} 
		do
			result=$(echo ${old_apps} | grep "${a}")
			if [[ "$result"x = ""x ]]; then
			    old_apps=`echo ${old_apps} " " ${a}`
			fi
		done
	fi
	
	old_apps=${old_apps:-$deployapps}
	
fi
etcdctl -C 192.168.1.237:2379 set ${key_apps} "${old_apps}"


if [ ${#deployapps[@]} > 0 ]; then 
	for a in ${deployapps} 
	do
		sh ${BASE_DIR}/deploy-yaml.sh -a $a -b $branch -n $ns
	done
fi
