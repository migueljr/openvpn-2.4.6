FROM alpine:3.9

RUN set -eux; \
    apk add --no-cache nginx;

COPY nginx.conf /etc/nginx/nginx.conf

COPY index.html /usr/share/nginx/html/index.html

COPY openvpn/client.conf /etc/openvpn/client.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]