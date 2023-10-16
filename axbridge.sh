#!/bin/bash

# Install required packages
sudo apt update
sudo apt install -y hostapd dnsmasq

# Unmask and enable hostapd
sudo systemctl unmask hostapd
sudo systemctl enable hostapd

# Enable dnsmasq
sudo systemctl enable dnsmasq

# Create /etc/systemd/network/bridge-br0.netdev
cat <<EOL | sudo tee /etc/systemd/network/bridge-br0.netdev
[NetDev]
Name=br0
Kind=bridge
EOL

# Create /etc/systemd/network/br0-member-eth0.network
cat <<EOL | sudo tee /etc/systemd/network/br0-member-eth0.network
[Match]
Name=eth0

[Network]
Bridge=br0
EOL

# Enable systemd-networkd
sudo systemctl enable systemd-networkd

# Modify /etc/dhcpcd.conf

# Insert "denyinterfaces" to the first line of the file
sudo sed -i '1s/^/denyinterfaces wlan0 eth0\n/' /etc/dhcpcd.conf

# Append "interface" and "static ip_address" to the end of the file
cat <<EOL | sudo tee -a /etc/dhcpcd.conf
interface br0
static ip_address=192.168.1.2/24
EOL

interface br0
static ip_address=192.168.1.2/24
EOL

# Unblock the WLAN
sudo rfkill unblock wlan

# Modify /etc/hostapd/hostapd.conf
cat <<EOL | sudo tee /etc/hostapd/hostapd.conf
country_code=US
interface=wlan0
bridge=br0
ssid=axbridge
hw_mode=g
channel=7
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=12345678
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOL

# Modify /etc/dnsmasq.conf
cat <<EOL | sudo tee /etc/dnsmasq.conf
interface=br0
bind-dynamic
domain-needed
bogus-priv
dhcp-range=192.168.1.81,192.168.1.254,255.255.255.0,24h
EOL

# Modify /etc/default/hostapd
sudo sed -i 's/#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/' /etc/default/hostapd

# Reboot
sudo systemctl reboot

