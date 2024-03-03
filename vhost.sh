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

#!/bin/bash

# Apache Virtual Host Management Script

# Function to add a new virtual host
add_virtual_host() {
    echo "Creating Apache virtual host: $1"
    read -p "Enter domain name (e.g., example.com): " domain_name

    # Check if domain already exists
    if [ -e "/etc/apache2/sites-available/$domain_name.conf" ]; then
        echo "Virtual host for $domain_name already exists."
        exit 1
    fi

	# Choose PHP version
	echo "Select PHP version:"
	PHP_VERSIONS=($(ls /usr/bin/php* | grep -oP '(?<=php)([0-9]\.[0-9]+)' | sort -V | uniq))
	for ((i=0; i<${#PHP_VERSIONS[@]}; i++)); do
		echo "$((i+1)). PHP ${PHP_VERSIONS[i]}"
	done

	read -p "Enter your choice: " choice
	selected_version="${PHP_VERSIONS[choice-1]}"

    case $php_version in
        1)
            php_version="7.4"
            ;;
        2)
            php_version="8.0"
            ;;
        *)
            echo "Invalid choice. Using default PHP version (7.4)."
            php_version="7.4"
            ;;
    esac

    # Create virtual host configuration
    sudo mkdir -p /var/www/$domain_name/public_html
    sudo chown -R $USER:$USER /var/www/$domain_name/public_html
    sudo chmod -R 755 /var/www

    cat <<EOF | sudo tee /etc/apache2/sites-available/$domain_name.conf > /dev/null
<VirtualHost *:80>
    ServerAdmin webmaster@$domain_name
    ServerName $domain_name
    DocumentRoot /var/www/$domain_name/public_html

    <Directory /var/www/$domain_name/public_html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined

    <FilesMatch \.php$>
        SetHandler "proxy:unix:/var/run/php/php$php_version-fpm.sock|fcgi://localhost/"
    </FilesMatch>
</VirtualHost>
EOF

    # Enable the virtual host
    sudo a2ensite $domain_name.conf

    # Reload Apache
    sudo systemctl reload apache2

    echo "Virtual host $domain_name created successfully."
}

# Main Script
echo "Apache Virtual Host Management Script"

add_virtual_host

