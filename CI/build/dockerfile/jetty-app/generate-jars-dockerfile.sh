#!/bin/sh

base_image=${1:-microblog}
app=${2:-microblog}
grp=${3:-output}
branch=${4:-smoke}
typ=${5:-war}

date=`date +"%Y-%m-%d %H:%m:%S"`
cat <<EOF > ./Dockerfile.base
# kingdee docker apps 
#
# VERSION               0.0.1

FROM  ${base_image}    

RUN echo "ping succeed ! this image build by kingdee ${date}"  > /kingdee/webapp/root\\\$${app}/$app/ping.html


EOF
