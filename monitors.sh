###
# Author: IT Infrastructure
# Description: Install node exporter as a daemon systemd && cAdvisor for docker monitoring
###

#!/bin/bash

echo """
==============================================================================
[*] Install node exporter as a daemon systemd && cAdvisor for docker monitoring!
==============================================================================
[*] Starting..
"""
echo"""
[*] Nodeexporter installing..
"""

# Download and extract Node Exporter
sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz
sudo tar -xvzf node_exporter-1.8.2.linux-amd64.tar.gz
sudo mv node_exporter-1.8.2.linux-amd64/node_exporter /usr/local/bin/


# Add node_exporter user with no login shell
sudo useradd --no-create-home --shell /bin/false node_exporter

# Set correct permissions for the binary
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Create nodeexporter daemon
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

echo """
cAdvisor running on: $(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1):8181
"""

echo """
=======================================
[+] Nodeexporter installation complete!
=======================================
"""

echo"""
[*] cAdvisor installing...
"""

echo"""
[*]  Check docker availability...
"""
docker version

# Download cAdvisor compose yml 
echo "
services:
    cadvisor:
        image: gcr.io/cadvisor/cadvisor
        ports:
          - 8181:8080
        volumes:
          - /:/rootfs:ro
          - /var/run:/var/run:ro
          - /sys:/sys:ro
          - /var/lib/docker/:/var/lib/docker:ro
        networks:
        - monitoring
networks:
  monitoring:
" | sudo tee /usr/local/lib/docker-compose.cadvisor.yml > /dev/null

# Bring up the service
sudo docker compose -f /usr/local/lib/docker-compose.cadvisor.yml up -d && \
sleep 30s && \

sudo docker ps
echo '[+] cAdvisor installation complete!'
echo """
Nodeexporter is running on: $(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1):9100
cAdvisor is running on: $(ip addr show eth0 | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1):8181

Note: Add both to prometheus.yml and restart service
"""
