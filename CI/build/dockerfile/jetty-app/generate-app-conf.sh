#!/bin/sh


PROG=`basename $0`
BASE_DIR=`dirname $0`

usage() {
    cat <<EOF
Usage: ${PROG} [OPTION]...
download war package for build docker iamges.
Example: ${PROG} -a microblog -b smoke -t war -o output

Options:
    -a, --app       	set the appcations. 
    -b, --branch    	set the git branch.
    -t, --type	    	set the appcation's type: war or jar.
    -o, --output    	set the jenkins dir.
    -r, --repository	set the docker push repository address.
    -v, --version		set docker image's version.
    -h, --help      	display this help and exit
EOF
    exit $1
}

ARGS=`getopt -n "$PROG" -a -o a:b:t:r:o:v:h -l app:,branch:,type:,output:,repository:,version:,help -- "$@"`
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
    -t|--type)
        typ="$2"
        shift 2
        ;;
    -o|--output)
        grp="$2"
        shift 2
        ;;
    -r|--repository)
        repository="$2"
        shift 2
        ;;
    -v|--version)
        version="$2"
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
app=${app:-microblog}
grp=${grp:-output}
branch=${branch:-smoke}
typ=${typ:-war}
repository=${repository:-'172.20.10.220:5000'}

redEcho() {
    [ -c /dev/stdout ] && {
        # if stdout is console, turn on color output.
        echo -ne "\033[1;31m"
        echo -n "$@"
        echo -e "\033[0m"
    } || echo "$@"
}

### generate file to uuid dir, save yaml file to dir
uuid=`date +%s`_${RANDOM}_$$
work_dir=/tmp/docker_image_tmp/${uuid}
mkdir -p ${work_dir}

#### clean
cleanupWhenExit() {
    rm -rf /tmp/docker_image_tmp/${uuid} &> /dev/null
}
trap "cleanupWhenExit" EXIT

curl -GET http://192.168.1.50:8098/dkr/scripts/listXT.txt -o listXT.txt

########### grp from app 
while read line;do
	redEcho "========== Start deploy $line from xtout =========="
	if [ "opensys.common"x = "$line"x ]; then
		continue
	fi
	map[$line]=xtout
done < ./listXT.txt

rm -f listXT.txt

if [ ! -z "${map[$app]}" ]; then
		grp=${map[$app]}
fi


########### replace env vars
confFile=${work_dir}/apps-properties/master.env
function replacevar()
{
        echo "Start updating configs in $1"
        while IFS='=' read -r f1 f2
        do
                f2=`echo $f2 | tr -d '\r'`
                redEcho "[INFO] Replacing $f1 to $f2.."
#               sed -i "s/\${$f1}/$f2/g" $1/*
                find $1/* -type f -print0 | xargs -0 sed -i "s/\${$f1}/$f2/g"
        done < $confFile
}

# Update conf repo
redEcho `printf "git clean %s/apps-properties and pull" ${work_dir}`
cd ${work_dir}
git clone git@172.20.10.91:developers/apps-properties.git
cd  apps-properties
git clean -fdx
git reset --hard HEAD
git checkout 201505
git pull

redEcho `printf "git clean %s/cloud-docker/kingdee/dockerfile/jetty-app and pull" ${work_dir}`
cd ${work_dir}
git clone git@172.20.10.91:architects/cloud-docker.git
cd  cloud-docker/kingdee/dockerfile/jetty-app
git clean -fdx
git reset --hard HEAD
git pull


redEcho "generate jetty deploy files and dockerfile"
sh generate-jetty-deploy.sh $app

if [ "voice"x = "$app"x ];then
	sh ${BASE_DIR}/ugly/generate-voice-dockerfile.sh $app $grp $branch $typ
else
	sh generate-dockerfile.sh $app $grp $branch $typ
fi

mkdir -p config

if [ -d ${work_dir}/apps-properties/$app ] && [ -f ${work_dir}/apps-properties/$app/ignore.common ];then
	cp ${work_dir}/apps-properties/${app}/* config/
	replacevar config
	echo "COPY config/* /kingdee/webapp/root\\\$${app}/$app/WEB-INF/config/" >> Dockerfile
elif [ -d ${work_dir}/apps-properties/$app ];then
	cp ${work_dir}/apps-properties/common_config/* config
	cp ${work_dir}/apps-properties/${app}/* config/
	replacevar config
	echo "COPY config/* /kingdee/webapp/root\\\$${app}/$app/WEB-INF/config/" >> Dockerfile
else
	cp ${work_dir}/apps-properties/common_config/* config/
	replacevar config
	echo "COPY config/* /kingdee/webapp/root\\\$${app}/$app/WEB-INF/config/" >> Dockerfile
fi

redEcho "building docker images ..."
docker build -t kingdee/${branch}/${app} -f Dockerfile .

redEcho "docker retag and push to repository"
docker rmi ${repository}/kingdee/${branch}/${app}:latest
#docker images | grep '${repository}/kingdee/${branch}/${app}' | awk '{print $3}' | xargs --no-run-if-empty  docker rmi -f 
docker tag kingdee/${branch}/${app}:latest ${repository}/kingdee/${branch}/${app}:latest
docker push ${repository}/kingdee/${branch}/${app}:latest

redEcho "docker retag date version images"
date=`date +"%Y-%m-%d-%H-%M"`
version=${version:-${date}}
docker tag kingdee/${branch}/${app}:latest ${repository}/kingdee/${branch}/${app}:${version}
docker push ${repository}/kingdee/${branch}/${app}:${version}


sh ../clean.sh
