FROM ubuntu:jammy

COPY --chmod=755 ./start.sh /usr/local/bin/

LABEL authors="Ethan Besson" \
    maintainer="Ethan Besson <contact@southlabs.fr>" \
    title="Simple Wordpress server" \
    description="Wordpress CMS for website" \
    documentation="https://wordpress.org/documentation/" \
    base.name="docker.io/library/ubuntu:jammy" \
    licenses="AFL-3.0" \
    source="https://github.com/docker-library/wordpress" \
    version="1.0.0"

RUN apt-get update && apt-get upgrade -y && \  
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php &&  \
    apt-get update && mkdir -p /run/php/ && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget nginx unzip php8.3 php8.3-common php8.3-curl php8.3-fpm php8.3-imap php8.3-redis php8.3-cli php8.3-snmp php8.3-xml php8.3-zip php8.3-mbstring php8.3-mysql php8.3-gd php-gd php-xml php-mysql php-mbstring


COPY wordpress-nginx /etc/nginx/sites-available/
COPY ./wordpress/ /var/www/wordpress/

# Nginx Config
RUN ln -s /etc/nginx/sites-available/wordpress-nginx /etc/nginx/sites-enabled/ && \
    rm -f /etc/nginx/sites-enabled/default && \
    chown -R www-data:www-data /var/www && \
    chmod -R 755 /var/www
    
    
# Wordpress Config    
RUN sed -i "s/database_name_here/wordpress/g" /var/www/wordpress/wp-config.php && \
    sed -i "s/username_here/wpuser/g" /var/www/wordpress/wp-config.php && \
    sed -i "s/password_here/wpuser/g" /var/www/wordpress/wp-config.php && \
    sed -i "s|define( 'AUTH_KEY',         'put your unique phrase here' );|define( 'AUTH_KEY',         '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php && \
    sed -i "s|define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );|define( 'SECURE_AUTH_KEY',  '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php && \
    sed -i "s|define( 'LOGGED_IN_KEY',    'put your unique phrase here' );|define( 'LOGGED_IN_KEY',    '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php && \
    sed -i "s|define( 'NONCE_KEY',        'put your unique phrase here' );|define( 'NONCE_KEY',        '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php && \
    sed -i "s|define( 'AUTH_SALT',        'put your unique phrase here' );|define( 'AUTH_SALT',        '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php && \
    sed -i "s|define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );|define( 'SECURE_AUTH_SALT', '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php && \
    sed -i "s|define( 'LOGGED_IN_SALT',   'put your unique phrase here' );|define( 'LOGGED_IN_SALT',   '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php && \
    sed -i "s|define( 'NONCE_SALT',       'put your unique phrase here' );|define( 'NONCE_SALT',       '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php && \
    service nginx restart && service php8.3-fpm restart

EXPOSE 80

VOLUME /var/www/wordpress

CMD ["/bin/bash", "/usr/local/bin/start.sh"]