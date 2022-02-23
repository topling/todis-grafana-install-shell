#!/bin/bash

grafana_admin_password=1234567
enable_admin_dashboard=false # false or anything

function server_config() {
    #server config
    todis_host=localhost
    todis_port=8000
    prometheus_port=9090
    prometheus_listen_port=9090
    prometheus_host=localhost
    grafana_host=localhost
    grafana_port=3000
}

function local_config() {
    #local docker config
    todis_host=192.168.31.3
    todis_port=55001
    prometheus_port=55003
    prometheus_listen_port=10003
    prometheus_host=192.168.31.3
    grafana_host=localhost
    grafana_port=10005
}

function grafana_install_config() {
    #local docker config
    todis_host=192.168.31.3
    todis_port=55001
    prometheus_port=55091
    prometheus_listen_port=10001
    prometheus_host=192.168.31.3
    grafana_host=localhost
    grafana_port=10002
}

function toplingdb_config() {
    #local docker config
    todis_host=192.168.31.3
    todis_port=55125
    prometheus_port=55121
    prometheus_listen_port=10001
    prometheus_host=192.168.31.3
    grafana_host=localhost
    grafana_port=10002
}

function oauth_config() {
    #local docker config
    todis_host=192.168.31.3
    todis_port=55001
    prometheus_port=55111
    prometheus_listen_port=10001
    prometheus_host=192.168.31.3
    grafana_host=localhost
    grafana_port=10002
}

function dell1_config() {
    #local config dell1
    todis_host=192.168.100.10
    todis_port=2011
    prometheus_port=55081
    prometheus_listen_port=10001
    prometheus_host=192.168.31.3
    grafana_host=localhost
    grafana_port=10002
}

function check_user() {
	if test "$USER" != "root"; then
		echo ""
		echo "need root"
		echo ""
		exit
	fi
}


#server_config
#local_config
#grafana_install_config
#toplingdb_config
#dell1_config
oauth_config

todis_host_port=${todis_host}:${todis_port}
prometheus_host_port=${prometheus_host}:${prometheus_port}

check_if_include_config="true"
