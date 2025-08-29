#!/bin/sh
# Script de firewall personalizado para OpenVPN

# Habilitar encaminhamento de pacotes no kernel
echo 1 > /proc/sys/net/ipv4/ip_forward

# Permitir tráfego na interface tun0
iptables -A INPUT -i tun0 -j ACCEPT
iptables -A FORWARD -i tun0 -j ACCEPT
iptables -A FORWARD -o tun0 -j ACCEPT

# Permitir tráfego estabelecido e relacionado
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# Registrar regras aplicadas
echo "Regras de firewall personalizadas aplicadas com sucesso"