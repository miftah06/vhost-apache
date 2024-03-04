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

    # Create virtual server with the specified options
    virtualmin create-domain --domain $domain_name --pass `openssl rand -base64 12` --ip $ip_address --php-version $selected_version --unix --dir --web --ssl --email --logrotate --spam --virus --mysql

    echo "Virtual server $domain_name created successfully with IP $ip_address and PHP $selected_version."
}

# Main Script
echo "Virtualmin Virtual Server Creation Script"

add_virtual_server "$1"
