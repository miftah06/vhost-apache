#!/bin/bash

# Install Apache2
sudo apt install curl -y && apt install wget -y
sudo apt-get update
sudo apt-get install apache2 -y
curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x
sudo apt install php8.2 php8.2-cli php8.2-{bz2,curl,mbstring,intl,zip,xml,cgi,gd,mysql}
sudo apt install php7.4 libapache2-mod-php7.4 php7.4-cli
sudo apt install php7.4 php7.4-cli php7.4-{bz2,curl,mbstring,intl,zip,xml,cgi,gd,mysql}
apt install php-redis-all-dev
apt search php | grep 8.2
#!/bin/bash

# Install Webmin
sudo sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
wget -qO - http://www.webmin.com/jcameron-key.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install webmin -y

echo "Webmin installation complete."

# Change permissions for scripts
chmod +x start.sh
chmod +x vhost.sh

echo "Installation complete."
