#!/bin/sh


PROG=`basename $0`
BASE_DIR=`dirname $0`

usage() {
    cat <<EOF
Usage: ${PROG} [OPTION]...
download war package for build docker iamges.
Example: ${PROG} -a microblog -b smoke -t war -o output

Options:
    -b, --branch    	set the git branch.
    -h, --help      	display this help and exit
EOF
    exit $1
}

ARGS=`getopt -n "$PROG" -a -o b:h -l branch:,help -- "$@"`
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
    -h|--help)
        usage
        ;;
    --)
        shift
        break
        ;;
    esac
done

# Download App packages
#app=${app:-microblog}
#grp=${grp:-output}
#branch=${branch:-smoke}
#typ=${typ:-war}
#repository=${repository:-'172.20.10.220:5000'}

redEcho() {
    [ -c /dev/stdout ] && {
        # if stdout is console, turn on color output.
        echo -ne "\033[1;31m"
        echo -n "$@"
        echo -e "\033[0m"
    } || echo "$@"
}

ns=${ns:-$branch}

key=`printf "/kingdee/git/%s/parentbranch" ${ns}`
parent_branch=`etcdctl -C 192.168.1.237:2379 get ${key}`


key_jars=`printf "/kingdee/git/%s/jars" ${ns}`
old_jars=`etcdctl -C 192.168.1.237:2379 get ${key_jars}`

key_apps=`printf "/kingdee/git/%s/deployapps" ${ns}`
old_apps=`etcdctl -C 192.168.1.237:2379 get ${key_apps}`


key_wars=`printf "/kingdee/git/%s/wars" ${ns}`
old_wars=`etcdctl -C 192.168.1.237:2379 get ${key_wars}`
function checkInWars() {
        echo "apps in : " ${1} 
        result=$(echo ${old_wars} | grep "${1}")
		if [[ "$result"x = ""x ]]; then
		    return 0
		fi
		return 1
}



key_apps=`printf "/kingdee/git/%s/deployapps" ${ns}`
old_apps=`etcdctl -C 192.168.1.237:2379 get ${key_apps}`

if [ $? -eq 0 ]; then
	if [ ${#old_apps[@]} > 0 ]; then 
		for a in ${old_apps} 
		do
			redEcho "build image for : " ${a}
			#inNamespace=$(checkInWars ${a})
			image=`printf "kingdee/%s/%s" ${parent_branch} ${a} `
			if ! checkInWars ${a} ; then
				redEcho "build image for : " ${a}
				sh ${BASE_DIR}/jarapps-build.sh -a ${a} -b ${parent_branch} -j "${old_jars}" -J ${branch} -i "${image}"
			fi
		done
	fi
fi
