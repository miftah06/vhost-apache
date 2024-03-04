#!/bin/bash

# Function to add a new virtual host
add_virtual_host() {
    echo "Creating Apache virtual host: $1"
    read -p "Enter domain name (e.g., example.com): " domain_name

    # Check if domain already exists
    if [ -e "/etc/apache2/sites-available/$domain_name.conf" ]; then
        echo "Virtual host for $domain_name already exists."
        exit 1
    fi

    read -p "Enter IP address (e.g., 127.0.0.2): " ip_address

    # Choose PHP version
    echo "Select PHP version:"
    PHP_VERSIONS=($(ls /usr/bin/php* | grep -oP '(?<=php)([0-9]\.[0-9]+)' | sort -V | uniq))
    for ((i=0; i<${#PHP_VERSIONS[@]}; i++)); do
        echo "$((i+1)). PHP ${PHP_VERSIONS[i]}"
    done

    read -p "Enter your choice: " choice
    selected_version="${PHP_VERSIONS[choice-1]}"

    case $selected_version in
        7.4|8.2)
            php_version="$selected_version"
            ;;
        *)
            echo "Invalid choice. Using default PHP version (7.4)."
            php_version="7.4"
            ;;
    esac

    read -p "Enter directory for website files (e.g., /var/www/domain_name/public_html): " website_dir

    # Create virtual host configuration
    sudo mkdir -p $website_dir
    sudo chown -R $USER:$USER $website_dir
    sudo chmod -R 755 $website_dir

    cat <<EOF | sudo tee /etc/apache2/sites-available/$domain_name.conf > /dev/null
<VirtualHost $ip_address:81>
    ServerAdmin webmaster@$domain_name
    ServerName $domain_name
    DocumentRoot $website_dir

    <Directory $website_dir>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/$domain_name-error.log
    CustomLog \${APACHE_LOG_DIR}/$domain_name-access.log combined

    <FilesMatch \.php$>
        SetHandler "proxy:unix:/var/run/php/php$php_version-fpm.sock|fcgi://localhost/"
    </FilesMatch>
</VirtualHost>
EOF

    # Enable the virtual host
    sudo a2ensite $domain_name.conf

    # Reload Apache
    sudo systemctl reload apache2

    echo "Virtual host $domain_name created successfully with IP $ip_address, PHP $php_version, and directory $website_dir."
}

# Main Script
echo "Apache Virtual Host Management Script"

add_virtual_host "$1"
