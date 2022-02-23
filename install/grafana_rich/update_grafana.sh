#!/bin/bash

if [ "${check_if_include_config}" = "" ]; then
	cur_path=$(cd $(dirname $0); pwd)
	source ${cur_path}/../config.sh
fi
check_user

sh ${cur_path}/uninstall_grafana.sh
sh ${cur_path}/install_grafana.sh
sleep 10
sh ${cur_path}/grafana_config.sh

