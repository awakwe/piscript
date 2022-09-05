#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo systemctl enable ssh
sudo systemctl start ssh
sudo apt-get install raspberrypi-ui-mods xrdp 
sudo adduser xrdp ssl-cert
sudo reboot
