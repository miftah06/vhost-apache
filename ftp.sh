#!/bin/bash

# Script to manage FTP for Virtual Hosts

# Function to install FTP server
install_ftp_server() {
    echo "Installing vsftpd FTP server..."
    sudo apt-get update
    sudo apt-get install vsftpd -y

    # Enable anonymous FTP access (optional)
    sudo sed -i 's/anonymous_enable=NO/anonymous_enable=YES/' /etc/vsftpd.conf
    sudo systemctl restart vsftpd

    echo "vsftpd FTP server installed and running."
}

# Function to create FTP user and set permissions
create_ftp_user() {
    echo "Creating FTP user for virtual host: $1"
    read -p "Enter FTP username: " ftp_user
    read -sp "Enter FTP password: " ftp_pass
    echo ""
    sudo useradd -m -s /bin/bash $ftp_user
    echo "$ftp_user:$ftp_pass" | sudo chpasswd
    sudo mkdir -p /var/www/$1/public_html
    sudo chown -R $ftp_user:$ftp_user /var/www/$1/public_html
    echo "FTP user $ftp_user created successfully for virtual host $1"

    # Display FTP information
    echo "FTP Information:"
    echo "FTP Server: your_ftp_server"
    echo "Username: $ftp_user"
    echo "Password: $ftp_pass"
    echo "Login Panel: ftp://your_ftp_server"
    echo "Upload Panel: ftp://your_ftp_server/upload"
}

# Main Script
echo "FTP Management for Virtual Hosts"

# Check if FTP server is installed
if [ ! -x "$(command -v vsftpd)" ]; then
    read -p "vsftpd FTP server is not installed. Do you want to install it now? (y/n): " install_choice
    if [ "$install_choice" = "y" ]; then
        install_ftp_server
    else
        echo "Exiting."
        exit 1
    fi
fi

# Menu
echo "1. Create FTP user for a virtual host"
echo "2. View FTP information"
echo "3. Run ftp-telegram.sh"
echo "4. Exit"

read -p "Enter your choice: " choice

case $choice in
    1)
        read -p "Enter virtual host domain: " domain
        create_ftp_user $domain
        ;;
    2)
        echo "Enter FTP information manually."
        ;;
    3)
        echo "Running ftp-telegram.sh..."
        ./ftp-telegram.sh
        ;;
    4)
        echo "Exiting."
        ;;
    *)
        echo "Invalid choice. Exiting."
        ;;
esac
