#!/bin/bash

if [ "${check_if_include_config}" = "" ]; then
	cur_path=$(cd $(dirname $0); pwd)
	source ${cur_path}/../config.sh
fi
check_user

cur_path=$(cd $(dirname $0); pwd)
download_path=${cur_path}/../../download
prometheus_service_file=${cur_path}/prometheus.service
prometheus_config_file=${cur_path}/prometheus.yml

sed "s/9090/${prometheus_listen_port}/g" ${cur_path}/prometheus.service.base > ${cur_path}/prometheus.service

#安装prometheus：
function prometheus_config() {
	configfile=prometheus.yml
	cd ${download_path}
	tar xf prometheus-2.29.0.linux-amd64.tar.gz
	mv prometheus-2.29.0.linux-amd64 /usr/local/prometheus
	cd /usr/local/prometheus/
	cp ${configfile} ${configfile}_back
	cp ${prometheus_config_file} .
	sed "s/prometheus_ip_port/${prometheus_host_port}/g" -i ${configfile}
	sed "s/process_exporter_ip_port/localhost:9256/g" -i ${configfile}
	sed "s/db_ip_port/${todis_host_port}/g" -i ${configfile}
}

function prometheus_dir() {
	groupadd prometheus
	useradd -g prometheus -s /sbin/nologin prometheus
	chown -R prometheus:prometheus  /usr/local/prometheus
	#mkdir -p /var/lib/prometheus
	#chown -R prometheus:prometheus /var/lib/prometheus/
	mkdir  /data/prometheus -p
	chown -R prometheus:prometheus /data/prometheus
}

function start_prometheus() {
	cp ${prometheus_service_file} /etc/systemd/system/prometheus.service
	systemctl enable prometheus.service
	systemctl restart prometheus.service
}

prometheus_config
prometheus_dir
start_prometheus
