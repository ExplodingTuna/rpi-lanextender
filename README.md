# rpi-lanextender
These are instructions to configure a raspberry pi to extend a static ip network over Wi-Fi.
- Format the raspberry pi SD card using rasp pi imager, and install Raspberry Pi OS Lite
- Insert the SD card into the raspberry pi and go throught the initial setup with your preferred settings
- Type “sudo raspi-config”, go into Localization Options, and configure the correct timezone
- Setup the current time with the formatL “sudo date -s ‘YYYY-MM-DD HH:MM:SS’ ”
- Type sudo apt update
- Type sudo apt upgrade, then Y when prompted
- Install hostapd and dnsmasq
```bash
sudo install hostapd
```
```bash
sudo install dnsmasq
```
- Unmask and enable hostapd so it starts on boot:
```bash
sudo systemctl unmask hostapd
```
```bash
sudo systemctl enable hostapd
```
-Now do the same for dnsmasq
```bash
sudo systemctl unmask hostapd
```
```bash
sudo systemctl enable dnsmasq
```
-Type “sudo nano /etc/systemd/network/bridge-br0.netdev” and enter the following:
```bash
[NetDev]
Name=br0
Kind=bridge
```
-Ctrl+O and Enter to save, Ctrl+X to exit
-Type sudo nano /etc/systemd/network/br0-member-eth0.network and enter the following:
```bash
[Match]
Name=eth0
[Network]
Bridge=br0
```
-Ctrl+O and Enter to save, Ctrl+X to exit
-Type sudo nano /etc/dhcpcd.conf and enter the following anywhere near the top:
```bash
denyinterfaces wlan0 eth0 
interface br0 //put this at the end of the file
static ip_address=192.168.1.2/24
```
-Type sudo rfkill unblock wlan
-Type sudo nano /etc/hostapd/hostapd.conf:
```bash
country_code=US
interface=br0
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
```
-Type sudo nano /etc/dnsmasq.conf:
```bash
interface=br0
bind-dynamic
domain-needed
bogus-priv
dhcp-range=192.168.1.81,192.168.1.254,255.255.255.0,24h
```
-Type sudo nano /etc/default/hostapd and remove the # from the DAEMON_CONF line and add inside the quotations:
```bash
/etc/hostapd/hostapd.conf
```
-Type sudo systemctl reboot
