#!/bin/sh

branch=$1
confd_conf_dir=$2

mkdir -p /usr/local/nginx/conf/conf.d/server



cat <<EOF >${confd_conf_dir}/templates/${branch}-upstream.tmpl
{{\$endpoints := getvs "/registry/services/endpoints/kingdee-${branch}/*"}}
{{range \$spec := \$endpoints}} {{\$data := json \$spec}} {{ if \$data.subsets }}
upstream {{\$data.metadata.name}} {	{{range \$si, \$se := \$data.subsets}} {{range  \$ai, \$ae := \$se.addresses}}
	server {{\$ae.ip}}:10091; {{ end }} {{ end }}
}{{ end }}
{{ end }}

{{\$endpoints := getvs "/registry/services/endpoints/kingdee-${branch}-ab/*"}}
{{range \$spec := \$endpoints}} {{\$data := json \$spec}} {{ if \$data.subsets }}
upstream {{\$data.metadata.name}}_ab {	{{range \$si, \$se := \$data.subsets}} {{range  \$ai, \$ae := \$se.addresses}}
	server {{\$ae.ip}}:10091; {{ end }} {{ end }}
}{{ end }}
{{ end }}

EOF

cat <<EOF >${confd_conf_dir}/templates/${branch}-location.tmpl
{{\$endpoints := getvs "/registry/services/endpoints/kingdee-${branch}/*"}}
{{range \$spec := \$endpoints}} {{\$data := json \$spec}} {{ if \$data.subsets }}

{{if exists (printf "/registry/services/endpoints/kingdee-${branch}-ab/%s-ab" \$data.metadata.name)}}
set \$group {{\$data.metadata.name}};
if (\$uri ~* "/kingdee.com/"){
        set \$group {{\$data.metadata.name}}_ab;
}
{{end}}

{{\$urls := split \$data.metadata.name "-"}}
location /{{index \$urls 0}} {
 	proxy_intercept_errors on;
 	error_page 401  /res/error/500.html;
 	error_page 403  /res/error/500.html;
 	error_page 404  /res/error/404.html;
	error_page 500  /res/error/500.html;
	{{if exists (printf "/registry/services/endpoints/kingdee-${branch}-ab/%s-ab" \$data.metadata.name)}}
	proxy_pass http://\$group;
	{{else}}
	proxy_pass http://{{\$data.metadata.name}};
	{{end}}
	
    #health_check;
    proxy_redirect off;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header Host \$http_host;
} {{ end }}{{ end }}

EOF


#############################################################
#######  first  tmp
#############################################################


cat <<EOF >${confd_conf_dir}/conf.d/${branch}-1.upstreams.toml

[template]
src = "${branch}-upstream.tmpl"
## nginx conf.d
dest = "/usr/local/nginx/conf/conf.d/stream/${branch}/${branch}.stream.conf"
mode = "0644"
keys = [
  "/registry/services/endpoints",
]
check_cmd = "/usr/local/nginx/sbin/nginx -t"
reload_cmd = "/usr/local/nginx/sbin/nginx -s reload"

EOF

cat <<EOF >${confd_conf_dir}/conf.d/${branch}-2.locations.toml

[template]
src = "${branch}-location.tmpl"
## nginx conf.d
dest = "/usr/local/nginx/conf/conf.d/location/${branch}/${branch}.locations.conf"
mode = "0644"
keys = [
  "/registry/services/endpoints",
]
#check_cmd = "/usr/local/nginx/sbin/nginx -t"
#reload_cmd = "/usr/local/nginx/sbin/nginx -s reload"

EOF

#############################################################
#############################################################

