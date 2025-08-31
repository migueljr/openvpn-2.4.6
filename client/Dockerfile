FROM alpine:3.9

RUN set -eux; \
    apk add --no-cache openvpn~=2.4.6 iptables kmod nano easy-rsa curl tar nginx; \
    # Workaround openvpn --version exiting with non-zero exit code on openvpn <= 2.4.x
    openvpn --version | grep -A100 -B100 2.4.6

# Criar diretórios necessários para o nginx
RUN mkdir -p /run/nginx /var/log/nginx /var/cache/nginx && \
    chown -R nginx:nginx /run/nginx /var/log/nginx /var/cache/nginx && \
    chmod 755 /run/nginx

COPY docker-entrypoint.sh /docker-entrypoint.sh

COPY nginx.conf /etc/nginx/nginx.conf

COPY index.html /usr/share/nginx/html/index.html

RUN chmod +x /docker-entrypoint.sh && \
    chown -R nginx:nginx /usr/share/nginx/html

RUN ls -l /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh", "nginx", "-g", "daemon off;"]
