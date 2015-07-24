#!/bin/sh

export JAVA_HOME=/kingdee/jdk

echo "Starting the server of pubacc"

echo "Current Dir: "`pwd`
/kingdee/play/play-1.2.6.1/play run /kingdee/jarapp/ --%prod -XX:MaxPermSize=256M