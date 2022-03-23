
#!/bin/bash

systemctl stop todis_exporter
rm -rf /usr/local/todis-exporter
rm -rf /usr/lib/systemd/system/todis-exporter.service
