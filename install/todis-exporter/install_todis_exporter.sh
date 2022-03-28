#!/bin/bash

cur_path=$(cd $(dirname $0); pwd)
bin_path=/usr/local/todis-exporter
service_file=${cur_path}/todis-exporter.service

mkdir -p ${bin_path}
cd ${bin_path}
groupadd prometheus
useradd -g prometheus -s /sbin/nologin prometheus
chown -R prometheus:prometheus ${bin_path}

if [ ! -f "${bin_path}/todis_exporter" ]; then
	cp ${cur_path}/../../download/todis_exporter ${bin_path}
fi

cp ${service_file} /usr/lib/systemd/system/

systemctl daemon-reload
systemctl enable todis-exporter
systemctl restart todis-exporter

