#!/bin/bash

cur_path=$(cd $(dirname $0); pwd)

if [ "${check_if_include_config}" = "" ]; then
	source ${cur_path}/../config.sh
fi
check_user

grafana_service_file=${cur_path}/grafana.service

function download_file() {
	bin_path=/usr/local/grafana
	mkdir -p ${bin_path}
	cd /usr/local/grafana
	cp ${cur_path}/../../download/grafana-8.2.4.linux-amd64.tar.gz .
	tar -zxf grafana-8.2.4.linux-amd64.tar.gz
	cd grafana-8.2.4
	unzip -oq ${cur_path}/../../download/grafana_build_file/grafana-8.2.4_v11.zip -d ./
	groupadd grafana
	useradd -g grafana -s /sbin/nologin grafana
	chown -R grafana:grafana /usr/local/grafana
}

function start_grafana() {
	cp ${grafana_service_file} /etc/systemd/system/grafana.service
	systemctl daemon-reload
	systemctl enable grafana.service
	systemctl restart grafana.service
}


function disable_auth() {
	local file=${1}
	local dest=${2}
	local start_line_num=`grep ${dest} ${file} -n | cut -d ":" -f 1`
	local end_line_num=`expr ${start_line_num} + 2`
	sed "${start_line_num},${end_line_num}s/enabled = true/enabled = false/g" -i ${file}
}


#安装grafana
function install_grafana() {
	cd ${bin_path}/grafana-8.2.4
	cp conf/sample.ini conf/custom.ini
	config_file=conf/custom.ini
	sed "s/;http_port = 3000/http_port = ${grafana_port}/g" -i ${config_file}
	sed "s/;enabled = false/enabled = true/g" -i ${config_file}
	sed "s/;org_name = Main Org./org_name = Main Org./g" -i ${config_file}
	sed "s/;org_role = Viewer/org_role = Viewer/g" -i ${config_file}
	sed "s/;enable_gzip = false/enable_gzip = true/g" -i ${config_file}
	sed '767,767s/;enabled = true/enabled = false/g' -i ${config_file}   ##disable [alerting]

	dest_list="auth.github auth.gitlab auth.google auth.grafana_com auth.azuread auth.okta"
	for dest in `echo ${dest_list}`;do
		disable_auth ${config_file} ${dest}
	done
}

download_file
install_grafana
start_grafana
