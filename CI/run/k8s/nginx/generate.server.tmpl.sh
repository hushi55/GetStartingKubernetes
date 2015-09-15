#!/bin/sh

branch=$1
confd_conf_dir=$2

mkdir -p /usr/local/nginx/conf/conf.d/server


cat <<EOF >${confd_conf_dir}/conf.d/${branch}-server.toml

[template]
src = "${branch}-server.tmpl"
## nginx conf.d
dest = "/usr/local/nginx/conf/conf.d/server/${branch}.server.conf"
mode = "0644"
keys = [
  "/registry/services/endpoints",
]
check_cmd = "/usr/local/nginx/sbin/nginx -t"
reload_cmd = "/usr/local/nginx/sbin/nginx -s reload"

EOF

cat <<EOF >${confd_conf_dir}/templates/${branch}-server.tmpl

{{\$endpoints := getvs "/registry/services/endpoints/kingdee-${branch}/*"}}
{{range \$spec := \$endpoints}} {{\$data := json \$spec}} {{ if \$data.subsets }}
upstream {{\$data.metadata.name}} {	{{range \$si, \$se := \$data.subsets}} {{range  \$ai, \$ae := \$se.addresses}}
	server {{\$ae.ip}}:10091; {{ end }} {{ end }}
}{{ end }}
{{ end }}

{{\$endpoints := getvs "/registry/services/endpoints/kingdee-${branch}-ab/*"}}
{{\$t := json (index $endpoints 0)}}
{{\$flag := \$t.metadata.name }}
{{range \$spec := \$endpoints}} {{\$data := json \$spec}} {{ if \$data.subsets }}
upstream {{\$data.metadata.name}}-ab {	{{range \$si, \$se := \$data.subsets}} {{range  \$ai, \$ae := \$se.addresses}}
	server {{\$ae.ip}}:10091; {{ end }} {{ end }}
}{{ end }}
{{ end }}
 
server {
        listen       80;
        server_name  ${branch}.kingdee;
        
        location / {
            #root   html;
            #index  microblog index.html index.htm;
            rewrite ^/.* http://\$server_name/microblog permanent;
        }

        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
        
        {{if exists (printf "/registry/services/endpoints/kingdee-${branch}-ab/%s" \$flag)}}
		if (\$http_debug ~* "v1"){
		        set \$group -ab;
		}
		{{end}}
        
        {{\$endpoints := getvs "/registry/services/endpoints/kingdee-${branch}/*"}}
{{range \$spec := \$endpoints}} {{\$data := json \$spec}} {{ if \$data.subsets }}

		{{\$urls := split \$data.metadata.name "-"}}
		location /{{index \$urls 0}} {
		 	proxy_intercept_errors on;
		 	error_page 401  /res/error/500.html;
		 	error_page 403  /res/error/500.html;
		 	error_page 404  /res/error/404.html;
			error_page 500  /res/error/500.html;
			{{if exists (printf "/registry/services/endpoints/kingdee-${branch}-ab/%s" \$data.metadata.name)}}
			proxy_pass http://{{\$data.metadata.name}}\$group;
			{{else}}
			proxy_pass http://{{\$data.metadata.name}};
			{{end}}
			
		    #health_check;
		    proxy_redirect off;
		    proxy_set_header X-Real-IP \$remote_addr;
		    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
		    proxy_set_header Host \$http_host;
		} {{ end }}{{ end }}
}

EOF