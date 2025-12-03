
# DHCP RELAY

nano /etc/network/interfaces

auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.84.0.2
    netmask 255.255.255.252

auto eth1
iface eth1 inet static
    address 10.84.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.84.0.5
    netmask 255.255.255.252

echo "nameserver 192.168.122.1" > /etc/resolv.conf

# IP Forward
echo 1 > /proc/sys/net/ipv4/ip_forward

# DEFAULT ROUTE
route add default gw 10.84.0.1

route add -net 10.84.0.8   netmask 255.255.255.252 gw 10.84.0.6   # A3
route add -net 10.84.0.12  netmask 255.255.255.252 gw 10.84.0.6   # A4
route add -net 10.84.0.128 netmask 255.255.255.128 gw 10.84.0.6   # A5
route add -net 10.84.0.16  netmask 255.255.255.252 gw 10.84.0.1   # A7
route add -net 10.84.0.20  netmask 255.255.255.252 gw 10.84.0.1   # A8
route add -net 10.84.0.24  netmask 255.255.255.252 gw 10.84.0.1   # A9
route add -net 10.84.0.64  netmask 255.255.255.192 gw 10.84.0.1   # A10
route add -net 10.84.0.32  netmask 255.255.255.248 gw 10.84.0.1   # A11
route add -net 10.84.0.28  netmask 255.255.255.252 gw 10.84.0.1   # A12
route add -net 10.84.0.40  netmask 255.255.255.248 gw 10.84.0.1   # A13


# DHCP RELAY
apt update -y
apt install -y isc-dhcp-relay

nano /etc/default/isc-dhcp-relay

SERVERS="10.84.0.43"
INTERFACES="eth0 eth1 eth2"
OPTIONS=""

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

service isc-dhcp-relay restart
