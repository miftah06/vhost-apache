#!/bin/bash

# Apache virtual host setup
# Usage: ./vhost.sh domainname

echo "Create Apache Virtual Host"
echo "Usage : chmod +x vhost.sh"
echo "./vhost.sh domainname"
echo "Enjoy !!! @gitnepal"

# Create directory for the domain
sudo mkdir -p /var/www/$1/
sudo chown -R $USER:$USER /var/www/$1/
sudo chmod -R 755 /var/www
echo "It works!" >> /var/www/$1/index.html

# Collect server admin and alias information
echo -e "\e[1;31mSubmit the form: \e[0m"
read -p "ServerAdmin eg- admin@demo.com : " ServerAdmin
read -p "ServerAlias eg- www.demo.com : " ServerAlias

# Create virtual host configuration file
sudo chmod -R 777 /etc/apache2/sites-available/
sudo echo "<VirtualHost *:80>
    ServerAdmin $ServerAdmin
    ServerName $1
    ServerAlias $ServerAlias
    DocumentRoot /var/www/$1
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" >> /etc/apache2/sites-available/$1.conf

# Enable the virtual host
sudo a2ensite $1.conf
sudo service apache2 reload

# Update hosts file
sudo chmod -R 777 /etc/hosts
echo "127.0.0.1 $1" >> /etc/hosts
sudo service apache2 reload

echo "Virtual host setup complete."
