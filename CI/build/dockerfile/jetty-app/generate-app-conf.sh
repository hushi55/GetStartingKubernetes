#!/bin/sh

# Download App packages
app=$1
grp=$2
branch=$3
typ=$4

confFile=/kingdee/buildsrv/apps-properties/master.env
function replacevar()
{
        echo "Start updating configs in $1"
        while IFS='=' read -r f1 f2
        do
                f2=`echo $f2 | tr -d '\r'`
                echo "[INFO] Replacing $f1 to $f2.."
#                sed -i "s/\${$f1}/$f2/g" $1/*
                find $1/* -type f -print0 | xargs -0 sed -i "s/\${$f1}/$f2/g"
        done < $confFile
}

# Update conf repo
cd /kingdee/buildsrv/apps-properties
git clean -fdx
git reset --hard HEAD
git checkout 201505
git pull

cd /kingdee/buildsrv/cloud-docker/kingdee/dockerfile/jetty-app
git clean -fdx
git reset --hard HEAD
git pull

#wget http://192.168.1.50:8098/dkr/$grp/$branch/$typ/$app.$typ
curl -GET http://192.168.1.50:8098/dkr/$grp/$branch/$typ/$app.$typ -o $app.$typ

sh generate-jetty-deploy.sh $app

sh generate-dockerfile.sh $app

mkdir -p config

if [ -d /kingdee/buildsrv/apps-properties/$app ] && [ -f /kingdee/buildsrv/apps-properties/$app/ignore.common ];then
	cp /kingdee/buildsrv/apps-properties/${app}/* config/
	replacevar config
	echo "COPY config/* /kingdee/webapp/root\\\$${app}/$app/WEB-INF/config/" >> Dockerfile
elif [ -d /kingdee/buildsrv/apps-properties/$app ];then
	cp /kingdee/buildsrv/apps-properties/common_config/* config
	replacevar config
	cp /kingdee/buildsrv/apps-properties/${app}/* config/
	echo "COPY config/* /kingdee/webapp/root\\\$${app}/$app/WEB-INF/config/" >> Dockerfile
else
	cp /kingdee/buildsrv/apps-properties/common_config/* config/
	replacevar config
	echo "COPY config/* /kingdee/webapp/root\\\$${app}/$app/WEB-INF/config/" >> Dockerfile
fi

docker build -t kingdee/${app}-${branch} -f Dockerfile .

rm -f /tmp/$app.$typ
