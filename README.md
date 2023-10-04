# rpi-lanextender
These are instructions to configure a raspberry pi to extend a static ip network over Wi-Fi.
1. Format the raspberry pi SD card using rasp pi imager, and install Raspberry Pi OS Lite
2. Setup the raspberry pi with the preferred settings
3. Type “sudo raspi-config”, go into Localization Options, and configure the correct timezone
4. Setup the current time with the formatL “sudo date -s ‘YYYY-MM-DD HH:MM:SS’ ”
5. Type sudo apt update
6. Type sudo apt upgrade, then Y when prompted
7. Enter the following:
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
8. Type “sudo nano /etc/systemd/network/bridge-br0.netdev” and enter the following:
[NetDev]
Name=br0
Kind=bridge
9. Ctrl+O and Enter to save, Ctrl+X to exit
10. Type sudo nano /etc/systemd/network/br0-member-eth0.network and enter the following:
[Match]
Name=eth0
[Network]
Bridge=br0
11. Ctrl+O and Enter to save, Ctrl+X to exit
12. Type sudo systemctl enable systemd-networkd and sudo systemctl enable dnsmasq
13. Type sudo nano /etc/dhcpcd.conf and enter:
denyinterfaces wlan0 eth0 //put this somewhere near the top
interface br0 //put this at the end of the file
static ip_address=192.168.1.2/24
14. Type sudo rfkill unblock wlan
15. Type sudo nano /etc/hostapd/hostapd.conf:
country_code=GB
interface=wlan0
bridge=br0
ssid=axbridge
hw_mode=g
channel=7
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=AardvarkBadgerHedgehog
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
16. Type sudo nano /etc/dnsmasq.conf:
Interface=br0

bind-dynamic
domain-needed
bogus-priv
dhcp-range=192.168.1.81,192.168.1.254,255.255.255.0,24h
17. Type sudo nano /etc/default/hostapd and remove the # from the DAEMON_CONF line and add
inside the quotations:
/etc/hostapd/hostapd.conf
18. Type sudo systemctl reboot
