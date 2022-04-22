#!/bin/bash

if [ "${check_if_include_config}" = "" ]; then
	source ./config.sh
fi

cur_path=$(cd $(dirname $0); pwd)

sh ${cur_path}/todis-exporter/uninstall_todis_exporter.sh
sh ${cur_path}/todis-exporter/install_todis_exporter.sh

sh ${cur_path}/prometheus/uninstall_prometheus.sh
sh ${cur_path}/prometheus/install_prometheus.sh 

if [ "${enable_admin_dashboard}" != "false" ];then
	sh ${cur_path}/process_exporter/install_process_exporter.sh
	sh ${cur_path}/node-exporter/install_node_exporter.sh
fi

sh ${cur_path}/grafana_rich/update_grafana.sh 
