FROM alpine:3.9

RUN set -eux; \
    apk add --no-cache openvpn~=2.4.6 iptables kmod nano easy-rsa curl tar; \
    # Workaround openvpn --version exiting with non-zero exit code on openvpn <= 2.4.x
    openvpn --version | grep -A100 -B100 2.4.6

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN curl -Lo cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64

RUN chmod +x cloudflared

RUN mv cloudflared /usr/local/bin/

RUN chmod +x /docker-entrypoint.sh

RUN ls -l /docker-entrypoint.sh


ENTRYPOINT ["/docker-entrypoint.sh"]
