#!/bin/sh
set -eu

# This iptables script to controlling traffic in the openvpn tunnel.
# In this example, clients can only perform DNS, HTTP and HTTPS requests to the world.

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

# Permitir tráfego HTTP entre containers na rede Docker (porta 80)
iptables -A FORWARD -i openvpn-246_openvpn-network -o openvpn-246_openvpn-network -p tcp --dport 80 -j ACCEPT

# Allow DNS from tunnel to world
iptables -A FORWARD -i tun+ -o "$NAT_INTERFACE" -p udp -m udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT

# Allow HTTP and HTTPS from tunnel to world
iptables -A FORWARD -i tun+ -o "$NAT_INTERFACE" -p tcp -m tcp -m conntrack --ctstate NEW -m multiport --dports 80,443 -j ACCEPT

# Permitir tráfego HTTP de entrada para o container client1
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Provisioning NAT iptables rules if NAT is enabled
if [ "$NAT" = 1 ]; then
    echo "NAT is enabled"
    echo "Provisioning NAT iptables rules"
    echo "NAT_INTERFACE: $NAT_INTERFACE"
    if [ "$NAT_MASQUERADE" = 1 ]; then
        echo "NAT_MASQUERADE is enabled"
        iptables -t nat -C POSTROUTING -o "$NAT_INTERFACE" -j MASQUERADE > dev/null 2>&1 || iptables -t nat -A POSTROUTING -o "$NAT_INTERFACE" -j MASQUERADE
    else
        echo "Not provisioning NAT iptables rules because NAT_MASQUERADE is disabled."
    fi
else
    echo "NAT is disabled."
    echo "Not adding NAT iptables rules"
fi

echo "Listing iptables rules:"
iptables -L -nv
echo "Listing iptables NAT rules:"
iptables -L -nv -t nat
