#!/bin/bash

systemctl stop process_exporter
rm -rf /usr/local/process-exporter
rm -rf /usr/lib/systemd/system/process_exporter.service
