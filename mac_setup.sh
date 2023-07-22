#!/bin/bash

# Install netatalk
sudo apt-get install netatalk -y

# Change the configuration of netatalk
sudo sed -i.bak 's/; \/home/\/home/g' /etc/netatalk/afp.conf

# Add netatalk restart command to .profile
echo 'sudo systemctl restart netatalk' >> ~/.profile

# Reboot the Raspberry Pi
sudo reboot
