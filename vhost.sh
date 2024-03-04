#!/bin/bash

# Virtualmin Virtual Server Creation and Deletion Script

# Function to add a new virtual server
add_virtual_server() {
    echo "Creating Virtualmin virtual server: $1"
    read -p "Enter domain name (e.g., example.com): " domain_name

    # Check if virtual server already exists
    if virtualmin list-domains --name $domain_name | grep -q $domain_name; then
        echo "Virtual server for $domain_name already exists."
        exit 1
    fi

    read -p "Enter IP address for the virtual server (e.g., 127.0.0.2): " ip_address

    # Prompt user for directory settings
    read -p "Enter directory for website files (e.g., /home/domain/public_html): " website_dir
    read -p "Enter directory for log files (e.g., /home/domain/logs): " log_dir

    # Set SMTP port to 587
    smtp_port=587

    # Create virtual server with the specified options
    virtualmin create-domain --domain $domain_name --pass `openssl rand -base64 12` --ip $ip_address --unix --dir --web --ssl --email --logrotate --spam --mysql --dir $website_dir --logdir $log_dir --smtp --smtp-port $smtp_port --default-website-port 81 --default-ssl-port 4443

    echo "Virtual server $domain_name created successfully with IP $ip_address, website directory $website_dir, log directory $log_dir, SMTP port $smtp_port, HTTP port 81, and HTTPS port 4443."
}

# Function to remove a virtual server
remove_virtual_server() {
    echo "Removing Virtualmin virtual server: $1"
    read -p "Enter domain name to delete: " domain_name

    # Check if virtual server exists
    if ! virtualmin list-domains --name $domain_name | grep -q $domain_name; then
        echo "Virtual server for $domain_name does not exist."
        exit 1
    fi

    # Remove virtual server
    virtualmin delete-domain --domain $domain_name

    echo "Virtual server $domain_name deleted successfully."
}

# Main Script
echo "Virtualmin Virtual Server Creation and Deletion Script"

# Check if operation specified
if [ "$1" == "add" ]; then
    add_virtual_server "$2"
elif [ "$1" == "remove" ]; then
    remove_virtual_server "$2"
else
    echo "Invalid operation. Usage: ./vhost.sh [add|remove] [domain_name]"
fi
