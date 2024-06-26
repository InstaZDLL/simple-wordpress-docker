FROM ubuntu:jammy

COPY --chmod=755 ./docker-entrypoint.sh /usr/local/bin/
COPY --chmod=755 ./healthcheck.sh /usr/local/bin/healthcheck.sh

LABEL authors="Ethan Besson" \
    maintainer="Ethan Besson <contact@southlabs.fr>" \
    title="Simple Wordpress server" \
    description="Wordpress CMS for website" \
    documentation="https://wordpress.org/documentation/" \
    base.name="docker.io/library/ubuntu:jammy" \
    licenses="AFL-3.0" \
    source="https://github.com/InstaZDLL/simple-wordpress-docker" \
    vendor="the Docker Community" \
    version="1.0.1" \
    url="https://github.com/InstaZDLL/simple-wordpress-docker"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php &&  \
    apt-get update && \
    mkdir -p /run/php/ && \
    mkdir -p /docker-entrypoint-initdb.d/ && \
    apt-get install -y wget nginx unzip php8.3 php8.3-common php8.3-curl php8.3-fpm php8.3-imap php8.3-mysqli php8.3-redis php8.3-cli php8.3-snmp php8.3-xml php8.3-zip php8.3-mbstring php8.3-mysql php8.3-gd mysql-client gosu

COPY --chmod=755 init.sql /docker-entrypoint-initdb.d/
COPY ./wordpress-nginx /etc/nginx/sites-available/
COPY ./wordpress/ /usr/src/wordpress/

RUN ln -s /etc/nginx/sites-available/wordpress-nginx /etc/nginx/sites-enabled/ && \
    rm -f /etc/nginx/sites-enabled/default && \
    chown -R www-data:www-data /usr/src/wordpress && \
    chmod -R 755 /usr/src/wordpress && \
    chown -R www-data:www-data /var/www && \
    chmod -R 755 /var/www && \
    service nginx restart && \
    service php8.3-fpm restart && \
    gosu www-data true

EXPOSE 80

VOLUME [/var/www/wordpress]

HEALTHCHECK --interval=5m --timeout=3s \
  CMD /usr/local/bin/healthcheck.sh || exit 1

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
