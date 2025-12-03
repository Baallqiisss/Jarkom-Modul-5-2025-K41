# nano /etc/network/interfaces

auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.84.0.43
    netmask 255.255.255.248
    gateway 10.84.0.41

echo "nameserver 192.168.122.1" > /etc/resolv.conf


# DHCP SERVER
apt update
apt install isc-dhcp-server -y

# nano /etc/default/isc-dhcp-server
INTERFACESv4="eth0"


# nano /etc/dhcp/dhcpd.conf
# Subnet A13 (tempat DHCP server berada) — kosong
subnet 10.84.0.40 netmask 255.255.255.248 {
}

# KHAMUL — A11: 10.84.0.32/29
subnet 10.84.0.32 netmask 255.255.255.248 {
    range 10.84.0.33 10.84.0.38;
    option routers 10.84.0.33;
    option broadcast-address 10.84.0.39;
    option domain-name-servers 10.84.0.30;
    default-lease-time 600;
    max-lease-time 3600;
}

# DURIN — A10: 10.84.0.64/26
subnet 10.84.0.64 netmask 255.255.255.192 {
    range 10.84.0.65 10.84.0.126;
    option routers 10.84.0.65;
    option broadcast-address 10.84.0.127;
    option domain-name-servers 10.84.0.30;
    default-lease-time 600;
    max-lease-time 3600;
}

# GILGALAD & CIRADAN — A5: 10.84.0.128/25
subnet 10.84.0.128 netmask 255.255.255.128 {
    range 10.84.0.129 10.84.0.254;
    option routers 10.84.0.129;
    option broadcast-address 10.84.0.255;
    option domain-name-servers 10.84.0.30;
    default-lease-time 600;
    max-lease-time 3600;
}

# ELENDIL & ISILDUR — A6: 10.84.1.0/24
subnet 10.84.1.0 netmask 255.255.255.0 {
    range 10.84.1.1 10.84.1.254;
    option routers 10.84.1.1;
    option broadcast-address 10.84.1.255;
    option domain-name-servers 10.84.0.30;
    default-lease-time 600;
    max-lease-time 3600;
}


service isc-dhcp-server restart


# FIREWALL — blok semua ping ke Vilya
apt install -y iptables
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
