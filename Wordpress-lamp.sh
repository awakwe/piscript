#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install apache2 php libapache2-mod-php mysql-server php-mysql -y
sudo systemctl start mysql.service
sudo service apache2 restart
cd /var/www/html/
sudo rm*
sudo wget http://wordpress.org/latest.tar.gz
sudo tar xzf latest.tar.gz
sudo mv wordpress/* .
sudo rm -rf wordpress latest.tar.gz
sudo chown -R www-data: .
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar 
sudo mv wp-cli.phar /usr/local/bin/wp
mysql -u root -e "CREATE DATABASE KasaDatabase";
Sudo mysql -u root -p "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'kasatech1010!'";
sudo mysql_secure_installation
sudo reboot
