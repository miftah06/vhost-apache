#!/bin/bash

# Install Apache2
sudo apt install curl -y && apt install wget -y && apt install mariadb-server -y
sudo apt-get update
sudo apt-get install apache2 -y
curl -sSL https://packages.sury.org/php/README.txt | sudo bash -x
sudo apt install php8.2 php8.2-cli php8.2-{bz2,curl,mbstring,intl,zip,xml,cgi,gd,mysql}
sudo apt install php7.4 libapache2-mod-php7.4 php7.4-cli
sudo apt install php7.4 php7.4-cli php7.4-{bz2,curl,mbstring,intl,zip,xml,cgi,gd,mysql}
#!/bin/bash

# Change permissions for scripts
chmod +x start.sh
chmod +x vhost.sh
sudo rm -rf /home/vps/index.html
sudo rm /swapfile

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo apt-get update

echo "Installing ssh scripts 1...."
wget --no-check-certificate https://raw.githubusercontent.com/miftah06/ADM-FREE/master/setup.sh && chmod +x setup.sh* && ./setup.sh*

# Install Webmin
sudo sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
wget -qO - http://www.webmin.com/jcameron-key.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install webmin -y

echo "Webmin installation complete."

echo "Installing myserver...."
sudo git clone https://github.com/rajkumardusad/MyServer.git
cd MyServer
chmod +x install

mkdir -p /etc/udp
mkdir -p /etc/udp/
cat <<NANI > /etc/udp/config.json
{
  "listen": ":36712",
  "stream_buffer": 33554432,
  "receive_buffer": 83886080,
  "auth": {
    "mode": "passwords"
  }
}
NANI
chmod +x /etc/udp/*

if [ -z "$1" ]; then
cat <<EOF > /etc/systemd/system/udp-custom.service
[Unit]
Description=FN

[Service]
User=root
Type=simple
ExecStart=/etc/udp/udp-custom server
WorkingDirectory=/etc/udp/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF
else
cat <<EOF > /etc/systemd/system/udp-custom.service
[Unit]
Description=FN

[Service]
User=root
Type=simple
ExecStart=/etc/udp/udp-custom server -exclude $1
WorkingDirectory=/etc/udp/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF
fi

cat <<NONF > /etc/systemd/system/udp-request.service
[Unit]
Description=FN
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/etc/udp
ExecStart=/etc/udp/udp-request -ip=$request_public_ip -net=$interface$Port -mode=system
Restart=always
RestartSec=3s

[Install]
WantedBy=multi-user.target6
NONF

echo start service udp-custom
systemctl start udp-custom &>/dev/null
systemctl enable udp-request &>/dev/null
systemctl start udp-request &>/dev/null
echo enable service udp-custom
systemctl enable udp-custom &>/dev/null

wget https://raw.githubusercontent.com/Rerechan02/UDP/main/udp.sh && chmod +x udp.sh && ./udp.sh
wget https://raw.githubusercontent.com/Rerechan02/UDP/main/req.sh && chmod +x req.sh && ./req.sh
wget https://raw.githubusercontent.com/Rerechan02/UDP/main/zi.sh && chmod +x zi.sh && ./zi.sh

echo "Installing ssh scripts 2...."
wget --no-check-certificate https://raw.githubusercontent.com/miftah06/1.0/main/setup.sh && chmod +x setup.sh.1* && ./setup.sh.1*
bash install

echo "Installation complete."
