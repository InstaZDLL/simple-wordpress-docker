FROM ubuntu:jammy

COPY wordpress /etc/nginx/sites-available/wordpress

RUN apt-get update && apt-get upgrade -y && \  
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php &&  \
    apt-get update && mkdir -p /run/php/ && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget nginx unzip php8.3 php8.3-common php8.3-curl php8.3-fpm php8.3-imap php8.3-redis php8.3-cli php8.3-snmp php8.3-xml php8.3-zip php8.3-mbstring php8.3-mysql php8.3-gd php-gd php-xml php-mysql php-mbstring && \
    wget https://wordpress.org/latest.zip && unzip latest.zip && rm -f latest.zip && mv wordpress /var/www/wordpress/ && \
    chown -R www-data:www-data /var/www && chmod -R 755 /var/www && \
    ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/ && rm -f /etc/nginx/sites-enabled/default && \
    mv /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php && \
    sed -i "s/database_name_here/wordpress/g" /var/www/wordpress/wp-config.php && \
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
    service nginx restart && service php8.3-fpm restart && \
    echo "#!/bin/bash\nservice php8.3-fpm start\nnginx -g 'daemon off;'" > /usr/local/bin/start.sh && chmod +x /usr/local/bin/start.sh

EXPOSE 80

VOLUME /var/www/wordpress

LABEL version="1.0"
LABEL description="Wordpress Server"
LABEL maintainer="Ethan Besson <contact@southlabs.fr>"

CMD ["/bin/bash", "/usr/local/bin/start.sh"]