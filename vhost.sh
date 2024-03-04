#!/bin/bash

# Virtualmin Virtual Server Creation Script

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

    # Choose PHP version
    echo "Select PHP version:"
    PHP_VERSIONS=($(virtualmin list-php-versions | awk '{print $1}' | grep -v Version))
    for ((i=0; i<${#PHP_VERSIONS[@]}; i++)); do
        echo "$((i+1)). PHP ${PHP_VERSIONS[i]}"
    done

    read -p "Enter your choice: " choice
    selected_version="${PHP_VERSIONS[choice-1]}"

    if [[ ! " ${PHP_VERSIONS[@]} " =~ " ${selected_version} " ]]; then
        echo "Invalid choice. Exiting."
        exit 1
    fi

    # Prompt user for directory settings
    read -p "Enter directory for website files (e.g., /home/domain/public_html): " website_dir
    read -p "Enter directory for log files (e.g., /home/domain/logs): " log_dir

    # Set SMTP port to 587
    smtp_port=587

    # Create virtual server with the specified options
    virtualmin create-domain --domain $domain_name --pass `openssl rand -base64 12` --ip $ip_address --php-version $selected_version --unix --dir --web --ssl --email --logrotate --spam --virus --mysql --dir $website_dir --logdir $log_dir --smtp --smtp-port $smtp_port

    echo "Virtual server $domain_name created successfully with IP $ip_address, PHP $selected_version, website directory $website_dir, log directory $log_dir, and SMTP port $smtp_port."
}

# Main Script
echo "Virtualmin Virtual Server Creation Script"

add_virtual_server "$1"
