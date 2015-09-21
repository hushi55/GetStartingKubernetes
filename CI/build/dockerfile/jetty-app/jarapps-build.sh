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
    -j, --jarapps		set depends jarapps.
    -J, --jarappbranch	set depends jarapps.
    -i, --image			set base images.
    -h, --help      	display this help and exit
EOF
    exit $1
}

ARGS=`getopt -n "$PROG" -a -o a:b:t:r:o:j:J:i:h -l app:,branch:,type:,output:,repository:,jarapps:,jarappbranch:,image:,help -- "$@"`
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
    -j|--jarapps)
        jarapps="$2"
        shift 2
        ;;
    -J|--jarappbranch)
        jarbranch="$2"
        shift 2
        ;;
    -i|--image)
        image="$2"
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
#while read line;do
#	if [ "opensys.common"x = "$line"x ] || [ "3gol"x = "$line"x ]; then
#		continue
#	fi
#	redEcho "========== Start deploy $line from xtout =========="
#	map[$line]='xtout'
#done < ./listXT.txt
#
#rm -f listXT.txt
#
#
#for animal in "${map[@]}" ; do
#    KEY=${animal%%:*}
#    VALUE=${animal#*:}
#    printf "%s likes to %s.\n" "$KEY" "$VALUE"
#done
#
#exit 0
#
#if [ "${map[$app]}" ]; then
#		redEcho "app: " $app
#		redEcho "xtong: " ${map[$app]}
#		grp=${map[$app]}
#fi

redEcho `printf "git clean %s/cloud-docker/kingdee/dockerfile/jetty-app and pull" ${work_dir}`
cd ${work_dir}
git clone git@172.20.10.91:architects/cloud-docker.git
cd  cloud-docker/kingdee/dockerfile/jetty-app
git clean -fdx
git reset --hard HEAD
git pull

sh generate-jars-dockerfile.sh ${image} ${app}

if [[ ! "$jarapps"x = ""x ]]; then
	
	mkdir -p tmp_${uuid}
	redEcho http://192.168.1.50:8098/dkr/$grp/$branch/war/$app.war tmp_${uuid}/$app.war
	curl -GET http://192.168.1.50:8098/dkr/$grp/$branch/war/$app.war -o tmp_${uuid}/$app.war
	unzip tmp_${uuid}/$app.war -d tmp_${uuid}
	
	
	for a in ${jarapps} 
	do
		redEcho 'ls tmp_${uuid}/WEB-INF/lib/com.kdweibo.${a}*'
		ls tmp_${uuid}/WEB-INF/lib/com.kdweibo.${a}*
		
		if [ $? -eq 0 ]; then
		
			echo "RUN curl -GET http://192.168.1.50:8098/dkr/$grp/$jarbranch/jar/com.kdweibo.${a}-${jarbranch}.jar -o /tmp/com.kdweibo.${a}-${jarbranch}.jar && \\ " >> Dockerfile.base
			echo	  "rm -f /kingdee/webapp/root\\\$${app}/$app/WEB-INF/lib/*.${a}*.jar && \\ " >> Dockerfile.base
			echo	  "cp /tmp/com.kdweibo.${a}-${jarbranch}.jar /kingdee/webapp/root\\\$${app}/$app/WEB-INF/lib/ &&  \\ " >> Dockerfile.base
			echo	  "rm -rf /tmp/*" >> Dockerfile.base
			
		fi
	done
	
	rm -rf tmp_${uuid}
	
fi

## loacl images
redEcho "building docker images ..."
docker build -t kingdee/${jarbranch}/${app} -f Dockerfile.base .



## repository images version is : latest and date
redEcho "docker retag and push to repository"
docker rmi ${repository}/kingdee/${jarbranch}/${app}:latest
docker tag kingdee/${jarbranch}/${app}:latest ${repository}/kingdee/${jarbranch}/${app}:latest
docker push ${repository}/kingdee/${jarbranch}/${app}:latest

date=`date +"%Y-%m-%d-%H-%M"`
redEcho "docker retag date version images :" $date
docker tag kingdee/${jarbranch}/${app}:latest ${repository}/kingdee/${jarbranch}/${app}:${date}
docker push ${repository}/kingdee/${jarbranch}/${app}:${date}

sh ../clean.sh

