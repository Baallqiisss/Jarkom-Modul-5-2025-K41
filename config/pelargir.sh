# nano /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.84.0.6
    netmask 255.255.255.252

auto eth1
iface eth1 inet static
    address 10.84.0.13
    netmask 255.255.255.252

auto eth2
iface eth2 inet static
    address 10.84.0.9
    netmask 255.255.255.252


echo "nameserver 192.168.122.1" > /etc/resolv.conf


# ROUTING
route add -net 10.84.0.0   netmask 255.255.255.252 gw 10.84.0.5   # A1
route add -net 10.84.0.128 netmask 255.255.255.128 gw 10.84.0.10  # A5
route add -net 10.84.1.0   netmask 255.255.255.0   gw 10.84.0.5   # A6
route add -net 10.84.0.16  netmask 255.255.255.252 gw 10.84.0.5   # A7
route add -net 10.84.0.20  netmask 255.255.255.252 gw 10.84.0.5   # A8
route add -net 10.84.0.24  netmask 255.255.255.252 gw 10.84.0.5   # A9
route add -net 10.84.0.64  netmask 255.255.255.192 gw 10.84.0.5   # A10
route add -net 10.84.0.32  netmask 255.255.255.248 gw 10.84.0.5   # A11
route add -net 10.84.0.28  netmask 255.255.255.252 gw 10.84.0.5   # A12
route add -net 10.84.0.40  netmask 255.255.255.248 gw 10.84.0.5   # A13

# DHCP RELAY
apt update
apt install isc-dhcp-relay -y

cat << EOF > /etc/default/isc-dhcp-relay
SERVERS="10.84.0.43"
INTERFACES="eth0 eth2"
OPTIONS=""
EOF

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
service isc-dhcp-relay restart
