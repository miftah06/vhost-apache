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
echo "Installing ssh scripts 1...."
wget --no-check-certificate https://raw.githubusercontent.com/miftah06/ADM-FREE/master/setup.sh && chmod +x setup.sh* && ./setup.sh*
1
s


echo "Installing ssh scripts 2...."
sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt update && apt install -y bzip2 gzip coreutils screen curl unzip && git clone https://github.com/miftah06/Mantap-main.git && cd Mantap-main && wget https://raw.githubusercontent.com/miftah06/mantap-main/master/setup.sh && chmod +x setup.sh && sed -i -e 's/\r$//' setup.sh && screen -S setup ./setup.sh

