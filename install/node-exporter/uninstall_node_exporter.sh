
#!/bin/bash

systemctl stop node_exporter
rm -rf /usr/local/node-exporter
rm -rf /usr/lib/systemd/system/node-exporter.service
