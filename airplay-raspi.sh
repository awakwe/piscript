#!/bin/bash
sudo apt update
sudo apt upgrade
sudo apt install autoconf libtool libdaemon-dev libasound2-dev libpopt-dev libconfig-dev
sudo apt install avahi-daemon libavahi-client-dev
sudo apt install libssl-dev
cd ~
git clone https://github.com/mikebrady/shairport-sync.git
cd shairport-sync
autoreconf -i -f
./configure --with-alsa --with-avahi --with-ssl=openssl --with-systemd --with-metadata
make
sudo make install
sudo systemctl enable shairport-sync
sudo service shairport-sync start
sudo rpi-update
