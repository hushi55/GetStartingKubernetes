#!/bin/sh

branch=$1

mkdir -p /usr/local/nginx/conf/conf.d/server

cat <<EOF >/usr/local/nginx/conf/conf.d/server/${branch}.server.conf

server {
        listen       80;
        server_name  ${branch}.kingdee;
        
        include  conf.d/stream/${branch}/*.conf; 
        include  conf.d/location/${branch}/*.conf; 

        location / {
            root   html;
            index  index.html index.htm;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
}

EOF