# nano /etc/network/interfaces

auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.84.0.18
    netmask 255.255.255.252    

auto eth1
iface eth1 inet static
    address 10.84.0.21
    netmask 255.255.255.252

auto eth2
iface eth2 inet static
    address 10.84.0.25
    netmask 255.255.255.252

echo "nameserver 192.168.122.1" > /etc/resolv.conf

# IP FORWARDING


# STATIC ROUTES
route add -net 10.84.0.0   netmask 255.255.255.252 gw 10.84.0.17   # A1
route add -net 10.84.0.4   netmask 255.255.255.252 gw 10.84.0.17   # A2
route add -net 10.84.0.8   netmask 255.255.255.252 gw 10.84.0.17   # A3
route add -net 10.84.0.12  netmask 255.255.255.252 gw 10.84.0.17   # A4
route add -net 10.84.0.128 netmask 255.255.255.128 gw 10.84.0.17   # A5
route add -net 10.84.1.0   netmask 255.255.255.0   gw 10.84.0.17   # A6
route add -net 10.84.0.64  netmask 255.255.255.192 gw 10.84.0.26   # A10 
route add -net 10.84.0.32  netmask 255.255.255.248 gw 10.84.0.26   # A11 
route add -net 10.84.0.28  netmask 255.255.255.252 gw 10.84.0.17   # A12 
route add -net 10.84.0.40  netmask 255.255.255.248 gw 10.84.0.17   # A13 


# DHCP RELAY

apt update
apt install isc-dhcp-relay -y

# nano /etc/default/isc-dhcp-relay
SERVERS="10.84.0.43"
INTERFACES="eth0 eth2"
OPTIONS=""

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

sysctl -p
service isc-dhcp-relay restart
