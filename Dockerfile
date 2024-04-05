FROM ubuntu:jammy

COPY --chmod=755 ./docker-entrypoint.sh /usr/local/bin/

LABEL authors="Ethan Besson" \
    maintainer="Ethan Besson <contact@southlabs.fr>" \
    title="Simple Wordpress server" \
    description="Wordpress CMS for website" \
    documentation="https://wordpress.org/documentation/" \
    base.name="docker.io/library/ubuntu:jammy" \
    licenses="AFL-3.0" \
    source="https://github.com/docker-library/wordpress" \
    vendor="the Docker Community" \
    version="1.0.0" \
    url="https://github.com/docker-library/wordpress"

ENV WORDPRESS_DATABASE_HOST=localhost
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && \  
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php &&  \
    apt-get update && mkdir -p /run/php/ && \
    apt-get install -y wget nginx unzip php8.3 php8.3-common php8.3-curl php8.3-fpm php8.3-imap php8.3-redis php8.3-cli php8.3-snmp php8.3-xml php8.3-zip php8.3-mbstring php8.3-mysql php8.3-gd php-gd php-xml php-mysql php-mbstring gosu

COPY wordpress-nginx /etc/nginx/sites-available/
COPY ./wordpress/ /var/www/wordpress/

RUN ln -s /etc/nginx/sites-available/wordpress-nginx /etc/nginx/sites-enabled/ && \
    rm -f /etc/nginx/sites-enabled/default && \
    chown -R www-data:www-data /var/www && \
    chmod -R 755 /var/www && \
    service nginx restart && \
    service php8.3-fpm restart && \
    gosu www-data true

EXPOSE 80

VOLUME [/var/www/wordpress]

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]