#!/bin/bash

# Install Apache2
sudo apt-get update
sudo apt-get install apache2 -y
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
