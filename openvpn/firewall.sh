#!/bin/sh
set -eu

# This iptables script to controlling traffic in the openvpn tunnel.
# Configuração liberal para permitir todo o tráfego necessário

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

# Permitir todo o tráfego de encaminhamento por padrão
iptables -P FORWARD ACCEPT

# Permitir todo o tráfego do túnel para o mundo
iptables -A FORWARD -i tun+ -o "$NAT_INTERFACE" -j ACCEPT

# Permitir todo o tráfego de retorno relacionado
iptables -A FORWARD -i "$NAT_INTERFACE" -o tun+ -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Garantir que o tráfego HTTP seja permitido explicitamente
iptables -A FORWARD -i tun+ -o "$NAT_INTERFACE" -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A FORWARD -i "$NAT_INTERFACE" -o tun+ -p tcp -m tcp --sport 80 -j ACCEPT

# Liberar acesso específico ao cliente 10.8.0.10
iptables -A FORWARD -d 10.8.0.10 -j ACCEPT
iptables -A FORWARD -s 10.8.0.10 -j ACCEPT
iptables -A INPUT -d 10.8.0.10 -j ACCEPT
iptables -A INPUT -s 10.8.0.10 -j ACCEPT
iptables -A OUTPUT -d 10.8.0.10 -j ACCEPT
iptables -A OUTPUT -s 10.8.0.10 -j ACCEPT

# Liberar especificamente a porta 80 do cliente 10.8.0.10
iptables -A FORWARD -d 10.8.0.10 -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -d 10.8.0.10 -p tcp --dport 80 -j ACCEPT
