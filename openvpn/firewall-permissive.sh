#!/bin/sh
set -eu

# This iptables script allows more permissive traffic in the openvpn tunnel.
# Allows HTTP traffic on any port and common application ports.

# Check if iptables is available and working
if ! command -v iptables >/dev/null 2>&1; then
    echo "Warning: iptables not found, skipping firewall rules"
    exit 0
fi

# Test if iptables can initialize the filter table
if ! iptables -L >/dev/null 2>&1; then
    echo "Warning: iptables filter table not available, skipping firewall rules"
    echo "This is normal in some Docker environments"
    exit 0
fi

# Drop everything by default from tunnel to world
iptables -P FORWARD DROP

# Allow DNS from tunnel to world
iptables -A FORWARD -i tun+ -o "$NAT_INTERFACE" -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT

# Allow HTTP and HTTPS from tunnel to world
iptables -A FORWARD -i tun+ -o "$NAT_INTERFACE" -p tcp -m tcp -m conntrack --ctstate NEW -m multiport --dports 80,443 -j ACCEPT

# Allow common application ports
iptables -A FORWARD -i tun+ -o "$NAT_INTERFACE" -p tcp -m tcp -m conntrack --ctstate NEW -m multiport --dports 5001,8080,3000,8000,9000 -j ACCEPT

# Allow established connections
iptables -A FORWARD -i tun+ -o "$NAT_INTERFACE" -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
