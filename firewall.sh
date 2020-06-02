#! /bin/sh

#es importante que enp0s8 sea el interfaz con red interna 1 (ip 192.168.57.0)
# enp0s9 con la red interna 2 (ip 192.168.58.0) y enp0s10 con la only-host (ip 192.168.55.0)

sudo iptables -F
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -A INPUT -i enp0s8 -j ACCEPT
sudo iptables -A INPUT -i enp0s9 -j ACCEPT
sudo iptables -A INPUT -d 192.168.55.2/32 -i enp0s10 -p icmp -m icmp --icmp-type 0 -j ACCEPT
sudo iptables -A INPUT -m conntrack --cstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -i enp0s3 -j ACCEPT
sudo iptables -A FORWARD -i enp0s8 -j ACCEPT
sudo iptables -A FORWARD -i enp0s9 -j ACCEPT
sudo iptables -A FORWARD -i enp0s3 -m conntrack --cstate NEW -j ACCEPT
sudo iptables -A FORWARD -m conntrack --cstate RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -d 192.168.57.2/32 -p tcp --dport 80 -j ACCEPT
sudo iptables -A FORWARD -d 192.168.59.2/32 -p tcp --dport 22 -j ACCEPT

sudo iptables -t nat -A PREROUTING -d 192.168.55.2/32 -p tcp --dport 80 -j DNAT --to-destination 192.168.57.2
sudo iptables -t nat -A PREROUTING -d 192.168.55.2/32 -p tcp --dport 80 -j DNAT --to-destination 192.168.59.2
sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o enp0s10 -j SNAT --to-source 192.168.55.2
