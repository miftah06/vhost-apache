#!/bin/bash

# FTP Management Script for Virtual Hosts

# Function to add FTP user for a virtual host
add_ftp_user() {
    echo "Adding FTP user for virtual host: $1"
    read -p "Enter FTP username: " ftp_user
    read -sp "Enter FTP password: " ftp_pass
    echo ""
    sudo useradd -m -s /bin/bash $ftp_user
    echo "$ftp_user:$ftp_pass" | sudo chpasswd
    sudo mkdir -p /var/www/$1/public_html
    sudo chown -R $ftp_user:$ftp_user /var/www/$1/public_html
    echo "FTP user $ftp_user added successfully for virtual host $1"
}

# Function to remove FTP user for a virtual host
remove_ftp_user() {
    echo "Removing FTP user for virtual host: $1"
    read -p "Enter FTP username to remove: " ftp_user
    sudo userdel -r $ftp_user
    sudo rm -rf /var/www/$1/public_html
    echo "FTP user $ftp_user removed successfully for virtual host $1"
}

# Function to deploy to Telegram using ftp-bot
deploy_to_telegram() {
    read -p "Enter your Telegram Bot token: " telegram_token
    read -p "Enter your Telegram Chat ID: " telegram_chat_id

    # Run ftp-bot with provided token and chat ID
    echo "Running ftp-bot to deploy to Telegram..."
    ./ftp-bot --token $telegram_token --chat_id $telegram_chat_id
}

# Main Script
echo "FTP Management Script for Virtual Hosts"

# Check if virtual host exists
if [ ! -d "/var/www/$1" ]; then
    echo "Virtual host $1 does not exist."
    exit 1
fi

# Menu
echo "1. Add FTP user"
echo "2. Remove FTP user"
echo "3. Deploy to Telegram"
read -p "Enter your choice: " choice

case $choice in
    1)
        add_ftp_user $1
        ;;
    2)
        remove_ftp_user $1
        ;;
    3)
        deploy_to_telegram
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac
