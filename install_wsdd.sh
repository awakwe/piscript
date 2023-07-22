#!/bin/bash

# Install git
sudo apt-get install git -y

# Clone wsdd repository
git clone https://github.com/christgau/wsdd.git

# Navigate to the cloned directory
cd wsdd

# Make the script executable
chmod +x src/wsdd.py

# Create a systemd service file for wsdd
echo "[Unit]
Description=Web Services Dynamic Discovery host daemon
After=network.target

[Service]
Type=simple
ExecStart=$(pwd)/src/wsdd.py
User=nobody
Group=nobody
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/wsdd.service

# Reload the systemd manager configuration
sudo systemctl daemon-reload

# Enable the wsdd service to start on boot
sudo systemctl enable wsdd

# Start the wsdd service immediately
sudo systemctl start wsdd
