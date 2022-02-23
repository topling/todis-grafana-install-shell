#!/bin/bash

cur_path=$(cd $(dirname $0); pwd)
bin_path=/usr/local/node-exporter
service_file=${cur_path}/node-exporter.service

mkdir -p ${bin_path}
cd ${bin_path}
groupadd prometheus
useradd -g prometheus -s /sbin/nologin prometheus
chown -R prometheus:prometheus ${bin_path}

if [ ! -f "${bin_path}/node_exporter-1.2.2.linux-amd64.tar.gz" ]; then
	cp ${cur_path}/../../download/node_exporter-1.2.2.linux-amd64.tar.gz ${bin_path}
	cd ${bin_path}
	tar -xvf node_exporter-1.2.2.linux-amd64.tar.gz
fi

cp ${service_file} /usr/lib/systemd/system/

systemctl daemon-reload
systemctl enable node-exporter
systemctl restart node-exporter

