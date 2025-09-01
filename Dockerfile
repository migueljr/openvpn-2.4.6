FROM alpine:3.9

RUN set -eux; \
    apk add --no-cache openvpn~=2.4.6 iptables kmod nano easy-rsa curl tar nginx; \
    # Workaround openvpn --version exiting with non-zero exit code on openvpn <= 2.4.x
    openvpn --version | grep -A100 -B100 2.4.6

COPY docker-entrypoint.sh /docker-entrypoint.sh


RUN chmod +x /docker-entrypoint.sh

RUN mkdir -p /etc/openvpn/ccd

RUN touch /etc/openvpn/ccd/powerfitness && echo "ifconfig-push 10.8.0.6 255.255.255.0" > /etc/openvpn/ccd/powerfitness

RUN touch /etc/openvpn/ccd/corpoperfeito && echo "ifconfig-push 10.8.0.10 255.255.255.0" > /etc/openvpn/ccd/corpoperfeito


RUN ls -l /docker-entrypoint.sh


ENTRYPOINT ["/docker-entrypoint.sh"]
