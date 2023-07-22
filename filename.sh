#!/bin/bash

# Update system packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Samba
sudo apt-get install samba -y

# Create Samba user
(echo 548620; echo 548620) | sudo smbpasswd -a tony

# Backup original Samba configuration file
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.backup

# Edit Samba configuration file
echo "[main]
path = /
available = yes
valid users = @tony
read only = no
browsable = yes
public = yes
writable = yes" | sudo tee -a /etc/samba/smb.conf

# Restart Samba service
sudo service smbd restart

# Reboot Raspberry Pi
sudo reboot
