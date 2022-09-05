#!/bin/bash
curl -sSL https://get.docker.com | sh
sudo apt-get install docker-compose
git clone https://gitlab.com/nm_hung93/dockerized-wordpress-on-raspberry-pi.git
curl -sL http://wordpress.org/latest.tar.gz | tar --strip 1 -xz -C data/wp/www
cd data/wp/www/
cp wp-config-sample.php wp-config.php
docker-compose -f docker-compose.yml up -d
