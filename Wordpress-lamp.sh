#!/bin/bash
sudo apt install apache2 -y
sudo apt install php -y
sudo apt install mysql-server php-mysql -y
sudo service apache2 restart
sudo wget http://wordpress.org/latest.tar.gz
sudo tar xzf latest.tar.gz
sudo mv wordpress/* .
sudo rm -rf wordpress latest.tar.gz
sudo chown -R www-data: .
Reboot