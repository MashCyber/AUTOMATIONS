###
# Author: IT Infrastructure
# Description: Install node exporter as a daemon systemd
###

#!/bin/bash

sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
sudo tar -xvzf node_exporter-1.8.2.linux-amd64.tar.gz
sudo mv node_exporter-1.8.2.linux-amd64/node_exporter /usr/local/bin/

#sudo touch /etc/systemd/system/node_exporter.service

sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOF

## Add user
sudo useradd -rs /bin/false node_exporter

sudo systemctl daemon-reload && \
sudo systemctl enable node_exporter && \
sudo systemctl start node_exporter && \
sudo systemctl status node_exporter


## Verify
curl http://localhost:9100/metrics
