#!/bin/bash

# FTP Bot Script for Telegram

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --token) token="$2"; shift ;;
        --chat_id) chat_id="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Function to send message to Telegram
send_message() {
    local message="$1"
    curl -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id=$chat_id -d text="$message" >/dev/null
}

# Function to add a new virtual host
add_virtual_host() {
    echo "Creating Apache virtual host: $1"
    read -p "Enter domain name (e.g., example.com): " domain_name

    # Check if domain already exists
    if [ -e "/etc/apache2/sites-available/$domain_name.conf" ]; then
        send_message "Virtual host for $domain_name already exists."
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

    case $selected_version in
        7.4|8.2)
            php_version="$selected_version"
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

    send_message "Virtual host $domain_name created successfully with PHP $php_version."
}