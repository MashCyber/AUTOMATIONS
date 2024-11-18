###
# Author: IT Infrastructure
# Description: Install node exporter as a daemon systemd
###

#!/bin/bash

# Download and extract Node Exporter
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
sudo tar -xvzf node_exporter-1.8.2.linux-amd64.tar.gz
sudo mv node_exporter-1.8.2.linux-amd64/node_exporter /usr/local/bin/


# Add node_exporter user with no login shell
sudo useradd --no-create-home --shell /bin/false node_exporter

# Set correct permissions for the binary
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Create nodeexporter daemon
# sudo cat <<EOF > /etc/systemd/system/node_exporter.service
# [Unit]
# Description=Prometheus Node Exporter
# After=network.target

# [Service]
# User=node_exporter
# Group=node_exporter
# ExecStart=/usr/local/bin/node_exporter

# [Install]
# WantedBy=default.target
# EOF

echo "[Unit]
Description=Prometheus Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target" | sudo tee /etc/systemd/system/node_exporter.service > /dev/null

# Reload systemd, enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
sudo systemctl status node_exporter

# Verify
curl http://localhost:9100/metrics
