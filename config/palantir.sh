# nano /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.84.0.14
    netmask 255.255.255.252
    gateway 10.84.0.13

echo "nameserver 192.168.122.1" > /etc/resolv.conf

# WEB SERVER

apt update
apt install -y apache2
service apache2 start
echo "<h1>Welcome to Palantir</h1>" > /var/www/html/index.html
service apache2 restart

# FIREWALL IPTABLES
apt install iptables -y

iptables -A INPUT -s 10.84.0.128/25 -m time --timestart 07:00 --timestop 15:00 -j ACCEPT
iptables -A INPUT -s 10.84.1.0/24   -m time --timestart 17:00 --timestop 23:00 -j ACCEPT

# BLOCK jika di luar jam
iptables -A INPUT -s 10.84.0.128/25 -j DROP
iptables -A INPUT -s 10.84.1.0/24   -j DROP

# Block everything else
iptables -A INPUT -j DROP

iptables -N PORTSCAN

# Logging ketika terdeteksi
iptables -A PORTSCAN -m limit --limit 2/min \
    -j LOG --log-prefix "PORT_SCAN_DETECTED: "

# Drop penyerang
iptables -A PORTSCAN -j DROP

# Tracking koneksi baru
iptables -A INPUT -m state --state NEW \
    -m recent --set --name PORTSCAN

# Jika hit lebih dari 15 dalam 20 detik → masuk chain PORTSCAN
iptables -A INPUT -m state --state NEW \
    -m recent --update --seconds 20 --hitcount 15 --name PORTSCAN \
    -j PORTSCAN

# Setelah masuk daftar hitam → tolak semua
iptables -A INPUT -m recent --rcheck --name PORTSCAN -j DROP
