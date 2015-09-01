#!/bin/sh

######################################
##### install confd     ##############
######################################

confd_version=0.10.0

CONFD_BIN=/kingdee/confd/bin/
CONFD_CONF=/kingdee/confd/conf/

mkdir -p ${CONFD_BIN}
mkdir -p ${CONFD_CONF}
mkdir -p ${CONFD_CONF}/{templates,conf.d}


## download confd bin
wget https://github.com/kelseyhightower/confd/releases/download/v${confd_version}/confd-${confd_version}-linux-amd64 -o ${CONFD_BIN}/confd

chmod +x ${CONFD_BIN}/confd

#cp ./conf.d/* ${CONFD_CONF}/conf.d
#cp ./conf.d/templates/master/location/location.tmpl ${CONFD_CONF}/templates
#cp ./conf.d/templates/master/upstream/upstream.tmpl ${CONFD_CONF}/templates




######################################
##### mkdir tree     ##############
######################################


mkdir -p /usr/local/nginx/conf/conf.d/{location,stream,server}

BRANCH=master

mkdir -p /usr/local/nginx/conf/conf.d/{location,stream}/${BRANCH}/

## 
sh ./nginx/generate.server.sh ${BRANCH}
sh ./nginx/generate.confd.conf.sh ${BRANCH} ${CONFD_CONF}



${CONFD_BIN}/confd -onetime -backend etcd -node 192.168.1.237:2379 -confdir=${CONFD_CONF}