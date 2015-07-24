#!/bin/sh


JAVA_COM=/kingdee/jdk/bin/java
APP_HOME=/kingdee/jarapp/rest

#JAVA_OPTS="-Xms1024M -Xmx1024M -Xss1M -XX:MaxPermSize=256M -XX:+UseParallelGC"
APP_CLASSPATH=${APP_HOME}/jar/main/main.jar:${APP_HOME}/jar/lib/*
APP_CONFIG_HOME=${APP_HOME}/config/
CONFIG_YAML=${APP_CONFIG_HOME}config.yaml

today=`date "+%Y%m%d"`
LOG_FILE=$APP_HOME"/logs/"$today".log"

${JAVA_COM} -Dapp_config_home=${APP_CONFIG_HOME} -Dorg.eclipse.jetty.util.UrlEncoding.charset=UTF-8 -cp ${APP_CLASSPATH} ${MAIN_CLASS} server ${CONFIG_YAML}