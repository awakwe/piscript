#!/bin/bash
sudo apt install -y linux-modules-extra-raspi
sudo apt install -y zram-tools
sudo apt autoremove --purge -y zram-config
sudo gedit /etc/default/zramswap
sudo sed -i -e 's/zswap.enabled=1/zswap.enabled=0/' /boot/firmware/cmdline.txt
wget https://teejeetech.com/product/flashit/
wget -O - https://teejeetech.com/scripts/jammy/install_nala | bash

shutdown now
