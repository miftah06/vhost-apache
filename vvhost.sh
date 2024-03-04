#!/bin/bash

# Function to add a new virtual server
add_virtual_server() {
    echo "Adding new Virtualmin virtual server: $1"
    read -p "Enter domain name (e.g., example.com): " domain_name
    read -p "Enter password for the new domain: " domain_password

    # Create virtual server with the specified options
    virtualmin create-domain --domain "$domain_name" --pass "$domain_password"

    echo "Virtual server $domain_name created successfully."
}

# Function to modify an existing virtual server
modify_virtual_server() {
    echo "Modifying Virtualmin virtual server: $1"
    read -p "Enter domain name to modify: " domain_name

    # Modify virtual server with the specified options
    virtualmin modify-domain --domain "$domain_name"

    echo "Virtual server $domain_name modified successfully."
}

# Function to remove a virtual server
remove_virtual_server() {
    echo "Removing Virtualmin virtual server: $1"
    read -p "Enter domain name to delete: " domain_name

    # Remove virtual server
    virtualmin delete-domain --domain "$domain_name"

    echo "Virtual server $domain_name deleted successfully."
}

# Main Script
echo "Virtualmin Virtual Server Management Script"

# Check if operation specified
if [ "$1" == "add" ]; then
    add_virtual_server "$2"
elif [ "$1" == "modify" ]; then
    modify_virtual_server "$2"
elif [ "$1" == "remove" ]; then
    remove_virtual_server "$2"
else
    echo "Invalid operation. Usage: ./vhost.sh [add|modify|remove] [domain_name]"
fi
