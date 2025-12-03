# nano /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.84.0.26
    netmask 255.255.255.252

auto eth1
iface eth1 inet static
    address 10.84.0.65
    netmask 255.255.255.192

auto eth2
iface eth2 inet static
    address 10.84.0.33
    netmask 255.255.255.248


echo "nameserver 192.168.122.1" > /etc/resolv.conf


route add -net 10.84.0.0  netmask 255.255.255.252 gw 10.84.0.25   #A1
route add -net 10.84.0.4  netmask 255.255.255.252 gw 10.84.0.25   #A2
route add -net 10.84.0.8  netmask 255.255.255.252 gw 10.84.0.25   #A3
route add -net 10.84.0.12 netmask 255.255.255.252 gw 10.84.0.25   #A4
route add -net 10.84.0.128 netmask 255.255.255.128 gw 10.84.0.25  #A5
route add -net 10.84.1.0  netmask 255.255.255.0   gw 10.84.0.25   #A6
route add -net 10.84.0.16 netmask 255.255.255.252 gw 10.84.0.25   #A7
route add -net 10.84.0.20 netmask 255.255.255.252 gw 10.84.0.25   #A8
route add -net 10.84.0.28 netmask 255.255.255.252 gw 10.84.0.25   #A12
route add -net 10.84.0.40 netmask 255.255.255.248 gw 10.84.0.25   #A13

# DHCP RELAY
apt update
apt install isc-dhcp-relay -y

nano /etc/default/isc-dhcp-relay
SERVERS="10.84.0.43"
INTERFACES="eth0 eth1 eth2"
OPTIONS=""

echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

sysctl -p
service isc-dhcp-relay restart

# KONFIGURASI FIREWALL IPTABLES
iptables -t nat -A PREROUTING -s 10.84.0.43 -d 10.84.0.32/29 \
  -j DNAT --to-destination 10.84.0.22
iptables -t nat -A POSTROUTING -d 10.84.0.22 -j MASQUERADE

# isolasi khamul
iptables -A FORWARD -s 10.84.0.32/29 -j DROP
iptables -A FORWARD -d 10.84.0.32/29 -j DROP
