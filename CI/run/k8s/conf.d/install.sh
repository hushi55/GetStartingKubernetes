#!/bin/sh

confd_version = 0.10.0

CONFD_BIN=/kingdee/confd/bin/
CONFD_CONF=/kingdee/confd/conf/

mkdir -p ${CONFD_BIN}
mkdir -p ${CONFD_CONF}
mkdir -p ${CONFD_CONF}/templates,conf.d

## download confd bin
curl https://github.com/kelseyhightower/confd/releases/download/v${confd_version}/confd-${confd_version}-linux-amd64 -o /kingdee/confd/bin/confd

cp ./conf.d/* ${CONFD_CONF}/conf.d
cp ./conf.d/templates/master/location/location.tmpl ${CONFD_CONF}/templates
cp ./conf.d/templates/master/upstream/upstream.tmpl ${CONFD_CONF}/templates

${CONFD_BIN}/confd -onetime -backend etcd -node 192.168.1.237:2379 -confdir=${CONFD_CONF}