FROM nginx:1.13.8-alpine
COPY html/ /usr/share/nginx/html
COPY .htpasswd /etc/nginx/.htpasswd
COPY conf.d /etc/nginx/conf.d/
COPY localtime /etc/localtime
RUN apk add --update bash curl
ENV NGINX_HOST documentation.servicess.alin.be
ENV NGINX_PORT 80
HEALTHCHECK --interval=10s --timeout=10s --retries=3 CMD curl -f http://localhost/ || exit 1
