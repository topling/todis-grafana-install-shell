#!/bin/bash

if [ "${check_if_include_config}" = "" ]; then
	cur_path=$(cd $(dirname $0); pwd)
	source ${cur_path}/../config.sh
fi
check_user

systemctl stop prometheus.service

rm -rf /usr/local/prometheus
rm -rf /var/lib/prometheus
rm -rf /data/prometheus

