#!/bin/sh

####### war not exist
# 3gol analyze 


Branch="master smoke"
APPS="activity addressbook assistant attendance \
beems calendar connector crm docrest \
		document dores event group im integration \
		invite message microblog miscellanea openservlet \
		p2f public push relation res \
		sapphire smscloudgateway smsgateway \
		snsapi solr \
		space task todo vote weixin \
		extmcloud inforecommend \
		manage mcloud openaccess openadmin \
		opencache openfacade openid openimport \
		openorg opentalk opentool syncdata innermanage \
		attendancelight clout freeflow leave lightapp \
		logthird maprest shorturl wechatclout workreport "
		

cd /kingdee/buildsrv/cloud-docker/kingdee/dockerfile/jetty-app

redEcho() {
    [ -c /dev/stdout ] && {
        # if stdout is console, turn on color output.
        echo -ne "\033[1;31m"
        echo -n "$@"
        echo -e "\033[0m"
    } || echo "$@"
}


redEcho $APPS

curl -GET http://192.168.1.50:8098/dkr/scripts/listXT.txt -o listXT.txt

while read line;do
	redEcho "========== Start deploy $line from xtout =========="
	if [ "opensys.common"x = "$line"x ]; then
		continue
	fi
	map[$line]=xtout
done < ./listXT.txt

#rm -f listXT.txt

grp=output

for a in ${APPS}
do
	redEcho "apps is : " ${a}
	
	if [ ! -z "${map[$a]}" ]; then
		grp=${map[$a]}
	fi
	
	redEcho "grp is : " ${grp}
	
	for b in ${Branch}
	do
		redEcho "branch is : " ${b} 
		sh generate-app-conf.sh -a ${a} -b ${b} -o ${grp}
	done
done

