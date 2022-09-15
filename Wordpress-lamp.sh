#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install apache2 php libapache2-mod-php php-mysql -y
sudo apt-get install default-mysql-server
sudo systemctl start mysql.service
sudo service apache2 restart
cd /var/www/html/
sudo rm *
sudo wget http://wordpress.org/latest.tar.gz
sudo tar xzf latest.tar.gz
sudo mv wordpress/* .
sudo rm -rf wordpress latest.tar.gz
sudo chown -R www-data: .
cd
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar 
sudo mv wp-cli.phar /usr/local/bin/wp
sudo mysql -u root -e "CREATE DATABASE KasaDatabase";
Sudo mysql -u root -p "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'kasatech1010!'";
sudo mysql_secure_installation
sudo reboot
