# nano /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 10.84.0.42
    netmask 255.255.255.248
    gateway 10.84.0.41


echo "nameserver 192.168.122.1" > /etc/resolv.conf

# DNS SERVER
apt update
apt install bind9 -y

nano /etc/bind/named.conf.local
zone "k41.com" {
    type master;
    file "/etc/bind/k41.com";
};

zone "0.84.10.in-addr.arpa" {
    type master;
    file "/etc/bind/0.84.10.in-addr.arpa";
};

nano /etc/bind/k41.com
$TTL    604800          ; Default cache time
@       IN      SOA     k41.com. root.k41.com. (
                        2025100401 ; Serial
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL
;

@       IN      NS      k41.com.
@       IN      A       10.84.0.42

nano /etc/bind/0.84.10.in-addr.arpa
$TTL    604800
@       IN      SOA     k41.com. root.k41.com. (
                        2025100401
                        604800
                        86400
                        2419200
                        604800 )
;

0.84.10.in-addr.arpa.   IN      NS      k41.com.
42      IN      PTR     k41.com.

ln -s /etc/init.d/named /etc/init.d/bind9
service bind9 restart

# FIREWALL IPTABLES
apt install -y iptables
# hanya Vilya (10.84.0.43) yang boleh akses DNS
iptables -A INPUT -p udp --dport 53 -s 10.84.0.43 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -s 10.84.0.43 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j DROP
iptables -A INPUT -p tcp --dport 53 -j DROP

# HAPUS RULES
iptables -L INPUT --line-numbers
iptables -D INPUT 1
