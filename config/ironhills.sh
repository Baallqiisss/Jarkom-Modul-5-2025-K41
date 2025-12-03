
# IRONHILLS - WEB SERVER (Static IP)
nano /etc/network/interfaces

auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.84.0.22
    netmask 255.255.255.252
    gateway 10.84.0.21

echo "nameserver 192.168.122.1" > /etc/resolv.conf


# WEB SERVER (APACHE2)
apt update
apt install -y apache2
service apache2 start

echo "<h1>Welcome to Ironhills, kenalin namaku aqis</h1>" > /var/www/html/index.html
service apache2 restart


# FIREWALL IPTABLES
apt install -y iptables

# Hanya dapat diakses oleh 3 subnet:
# 1. A11: 10.84.0.32/29
# 2. A10: 10.84.0.64/26
# 3. A6 : 10.84.1.0/24
# Dan hanya boleh diakses pada hari Sabtu & Minggu

iptables -A INPUT -s 10.84.0.32/29 -m time --weekdays Sat,Sun -j ACCEPT
iptables -A INPUT -s 10.84.0.64/26 -m time --weekdays Sat,Sun -j ACCEPT
iptables -A INPUT -s 10.84.1.0/24 -m time --weekdays Sat,Sun -j ACCEPT

# Jika bukan weekend → DROP
iptables -A INPUT -s 10.84.0.32/29 -j DROP
iptables -A INPUT -s 10.84.0.64/26 -j DROP
iptables -A INPUT -s 10.84.1.0/24 -j DROP

# Selain subnet-subnet itu → DROP semua
iptables -A INPUT -j DROP
