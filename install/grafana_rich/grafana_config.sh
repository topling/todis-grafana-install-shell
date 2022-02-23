#!/bin/bash

cur_path=$(cd $(dirname $0); pwd)
if [ "${check_if_include_config}" = "" ]; then
	source ${cur_path}/../config.sh
fi

grafana_host_port=localhost:${grafana_port}

user="admin"
password="${grafana_admin_password}"

curl_head='-H "HTTP/1.1" -H "Accept: application/json" -H "Content-Type: application/json"'
http_grafana="http://${user}:${password}@${grafana_host_port}"

function change_password() {
	grafana_addr=$1
	body="{\"password\":\"${password}\"}"
	cmd="curl -s -X PUT ${curl_head} -d '${body}' -i http://${user}:admin@${grafana_addr}/api/admin/users/1/password"
	result=`eval ${cmd}`
	echo -e ${cmd} "\n" ${result} "\n"
}

function create_datasource() {
	prometheus_addr=$1
	body="{\"name\":\"Prometheus\",\"type\":\"prometheus\",\"url\":\"http://${prometheus_addr}\",\"access\":\"proxy\"}"
	cmd="curl -s -X POST ${curl_head} -d '${body}' -i ${http_grafana}/api/datasources"
	result=`eval ${cmd}`
	echo -e ${cmd} "\n" ${result} "\n"
}

function create_dashboard() {
	file=${cur_path}/dashboard/$1
        if [ $# = 2 ];then
		cmd="sed -e '50,\$s|\"folderId\":.*\$|\"folderId\": ${2}|g' -i ${file}"
		echo ${cmd}
		eval ${cmd}
	fi
	cmd="curl -s -X POST ${curl_head} -d @${file} -i ${http_grafana}/api/dashboards/db"
	result=`eval ${cmd}`
	echo -e ${cmd} "\n" ${result} "\n"
	last_dashboard_id=`echo "${result}"|sed 's/,/\n/g'|grep '"id":'|cut -d ":" -f 2|sed 's/"//g'`
	last_dashboard_url=`echo "${result}"|sed 's/,/\n/g'|grep '"url":'|cut -d ":" -f 2|sed 's/"//g'`
}

function add_dashboard_to_list() {
	dest="$1"
	url="$last_dashboard_url"
	sed "s#$dest#$url#g" -i ${cur_path}/dashboard/dashboard-list.json
}

function change_default_dashboard() {
	dashboard_id=$1
	cmd="curl -s -X PUT ${curl_head} -d '{\"theme\":\"\",\"homeDashboardId\":${dashboard_id},\"timezone\":\"\"}' ${http_grafana}/api/org/preferences"
	result=`eval ${cmd}`
	echo -e ${cmd} "\n" ${result} "\n"
}

function create_folder() {
	fold_name=$1
	cmd="curl -s -X POST ${curl_head} -d '{\"title\": \"${fold_name}\"}' ${http_grafana}/api/folders"
	result=`eval ${cmd}`
	echo -e ${cmd} "\n" ${result} "\n"
	last_fold_id=`echo "${result}"|sed 's/,/\n/g'|grep '"id":'|cut -d ":" -f 2|sed 's/"//g'`
	last_fold_uid=`echo "${result}"|sed 's/,/\n/g'|grep '"uid":'|cut -d ":" -f 2|sed 's/"//g'`
}

function update_folder_permissions() {
	fold_uid=$1
	grafana_addr=$2
	cmd="curl -s -X POST ${curl_head} -d '{\"items\":[]}' ${http_grafana}/api/folders/${fold_uid}/permissions"
	result=`eval ${cmd}`
	echo -e ${cmd} "\n" ${result} "\n"
}

function create_dashboard_to_list() {
	create_dashboard ${1}
	add_dashboard_to_list ${2}
}

function customer_config() {
	cp ${cur_path}/dashboard/dashboard-list-base.json ${cur_path}/dashboard/dashboard-list.json

	create_dashboard_to_list properties-all.json "properties-all-url"
	create_dashboard_to_list properties-cfstat.json "properties-cfstat-url"
	create_dashboard_to_list properties-common.json "properties-common-url"
	create_dashboard_to_list properties-level.json "properties-level-url"
	create_dashboard_to_list ticker-simple.json "ticker-url"
	create_dashboard_to_list ticker_aggregate.json "ticker-aggregate-url"

	create_dashboard_to_list length-histogram.json "length-histogram-url"
	create_dashboard_to_list rocksdb-histogram-all.json "engine-histogram-url"
	create_dashboard_to_list rocksdb-histogram-common.json "engine-histogram-common-url"
	create_dashboard_to_list rocksdb-histogram-compaction.json "engine-histogram-compaction-flush-url"
	create_dashboard_to_list time-histogram.json "time-histogram-url"
	
	create_folder rich
	create_dashboard double-line-histogram-length.json ${last_fold_id}
	create_dashboard double-line-histogram-rocksdb-common.json ${last_fold_id}
	create_dashboard double-line-histogram-rocksdb-compaction.json ${last_fold_id}
	create_dashboard double-line-histogram-rocksdb-all.json ${last_fold_id}
	create_dashboard double-line-histogram-time.json ${last_fold_id}

	create_folder list
	create_dashboard dashboard-list.json ${last_fold_id}

	change_default_dashboard ${last_dashboard_id}
}

function admin_config() {
	create_folder admin
	update_folder_permissions ${last_fold_uid}
	create_dashboard process-exporter.json ${last_fold_id}
	create_dashboard node-exporter.json ${last_fold_id}
}

change_password ${grafana_host_port}
create_datasource ${prometheus_host_port}
customer_config

if [ "${enable_admin_dashboard}" != "false" ];then
	admin_config
fi
