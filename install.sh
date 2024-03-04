#!/bin/bash

# Install Apache2
sudo apt install curl -y && apt install wget -y && apt install mariadb-server -y
sudo apt-get update
sudo apt-get install apache2 -y
curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x
sudo apt install php8.2 php8.2-cli php8.2-{bz2,curl,mbstring,intl,zip,xml,cgi,gd,mysql}
sudo apt install php7.4 libapache2-mod-php7.4 php7.4-cli
sudo apt install php7.4 php7.4-cli php7.4-{bz2,curl,mbstring,intl,zip,xml,cgi,gd,mysql}
apt install php-redis-all-dev
apt search php | grep 8.2
#!/bin/bash


echo "Installing ssh scripts 1...."
wget --no-check-certificate https://raw.githubusercontent.com/miftah06/ADM-FREE/master/setup.sh && chmod +x setup.sh* && ./setup.sh*


echo "Installing ssh scripts 2...."
wget --no-check-certificate https://raw.githubusercontent.com/miftah06/1.0/main/setup.sh && chmod +x setup.sh.1* && ./setup.sh.1*


# Install Webmin
sudo sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
wget -qO - http://www.webmin.com/jcameron-key.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install webmin -y

echo "Webmin installation complete."

echo "Installing myserver...."
sudo git clone https://github.com/rajkumardusad/MyServer.git
cd Myserver
chmod +x install
bash install

# Change permissions for scripts
chmod +x start.sh
chmod +x vhost.sh
sudo rm -rf /home/vps/index.html

echo "Installation complete."