#!/bin/bash

# MariaDB Installation and Setup
echo "Updating system..."
sudo apt update && sudo apt upgrade
echo "Installing MariaDB..."
sudo apt install -y mariadb-server
echo "Running MariaDB secure installation..."
sudo mysql_secure_installation

# Follow the prompts to set up MariaDB, including setting the root password, creating a new user, and granting permissions

# Mattermost Server Installation and Setup
echo "Creating Mattermost directory..."
sudo mkdir -p /opt/mattermost
echo "Downloading Mattermost..."
wget -P /opt/mattermost https://github.com/SmartHoneybee/ubiquitous-memory/releases/download/v5.32.1/mattermost-v5.32.1-linux-arm.tar.gz
echo "Extracting Mattermost..."
sudo tar -xvf /opt/mattermost/mattermost-v5.32.1-linux-arm.tar.gz -C /opt/mattermost
echo "Creating Mattermost user..."
sudo useradd --system --user-group --no-create-home mattermost
echo "Changing ownership of Mattermost directory..."
sudo chown -R mattermost:mattermost /opt/mattermost/

# Manual step to modify config.json file
echo "Please modify the config.json file now..."

# Create a Systemd Service for Mattermost
echo "Creating Mattermost service..."
echo '[Unit]
Description=Mattermost
After=network.target
After=mysql.service
Requires=mariadb.service

[Service]
Type=notify
ExecStart=/opt/mattermost/bin/mattermost
TimeoutStartSec=3600
Restart=always
RestartSec=10
WorkingDirectory=/opt/mattermost
User=mattermost
Group=mattermost
LimitNOFILE=49152

[Install]
WantedBy=multi-user.target' | sudo tee /lib/systemd/system/mattermost.service

echo "Reloading services..."
sudo systemctl daemon-reload
echo "Enabling Mattermost service..."
sudo systemctl enable mattermost.service
echo "Starting Mattermost service..."
sudo systemctl start mattermost.service

# Complete the Setup is done manually
echo "Please complete the setup in your web browser..."
