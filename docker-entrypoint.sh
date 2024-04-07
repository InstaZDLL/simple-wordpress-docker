#!/bin/bash

# Use default values if the variables are not set
: "${WORDPRESS_HOST:=localhost}"
: "${WORDPRESS_DATABASE_HOST:=localhost}"
: "${WORDPRESS_DATABASE:=wordpress}"
: "${WORDPRESS_DATABASE_USER:=wpuser}"
: "${WORDPRESS_DATABASE_PASSWORD:=wpuser}"

if [ "$WORDPRESS_DATABASE_HOST" = "localhost" ]; then
    echo "[Warning] Database host is set to localhost"
    exit 1
fi

if [ "$WORDPRESS_HOST" = "localhost" ]; then
    echo -e '[Warning] The variable WORDPRESS_HOST has not been defined so all resources will only be available on localhost\nIf you want your wordpress to work online, change this variable'
fi

if [ ! -f /docker-entrypoint-initdb.d/flagfile ]; then
    if [ "$WORDPRESS_HOST" = "localhost" ]; then
        echo -e '[Warning] The variable WORDPRESS_HOST has not been defined so all resources will only be available on localhost\nIf you want your wordpress to work online, change this variable'
        mysql -u ${WORDPRESS_DATABASE_USER} -p${WORDPRESS_DATABASE_PASSWORD} -h ${WORDPRESS_DATABASE_HOST} ${WORDPRESS_DATABASE} < /docker-entrypoint-initdb.d/init.sql
    fi

    if [ "$WORDPRESS_HOST" = "localhost" ]; then
        echo 'Wordpress resources point to http://localhost'
    else
        sed -i "s/http:\/\/localhost/http:\/\/${WORDPRESS_HOST}/g" /docker-entrypoint-initdb.d/init.sql
        echo 'The path of wordpress resources have changed, they point to http://${WORDPRESS_HOST}'
    fi

    touch /docker-entrypoint-initdb.d/flagfile
fi

if grep -q "put your unique phrase here" /var/www/wordpress/wp-config.php; then
    sed -i "s/database_name_here/${WORDPRESS_DATABASE}/g" /var/www/wordpress/wp-config.php
    sed -i "s/username_here/${WORDPRESS_DATABASE_USER}/g" /var/www/wordpress/wp-config.php
    sed -i "s/password_here/${WORDPRESS_DATABASE_PASSWORD}/g" /var/www/wordpress/wp-config.php
    sed -i "s/'localhost'/'${WORDPRESS_DATABASE_HOST}'/g" /var/www/wordpress/wp-config.php
    sed -i "s|define( 'AUTH_KEY',         'put your unique phrase here' );|define( 'AUTH_KEY',         '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php
    sed -i "s|define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );|define( 'SECURE_AUTH_KEY',  '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php
    sed -i "s|define( 'LOGGED_IN_KEY',    'put your unique phrase here' );|define( 'LOGGED_IN_KEY',    '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php
    sed -i "s|define( 'NONCE_KEY',        'put your unique phrase here' );|define( 'NONCE_KEY',        '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php
    sed -i "s|define( 'AUTH_SALT',        'put your unique phrase here' );|define( 'AUTH_SALT',        '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php
    sed -i "s|define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );|define( 'SECURE_AUTH_SALT', '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php
    sed -i "s|define( 'LOGGED_IN_SALT',   'put your unique phrase here' );|define( 'LOGGED_IN_SALT',   '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php
    sed -i "s|define( 'NONCE_SALT',       'put your unique phrase here' );|define( 'NONCE_SALT',       '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php
    echo 'keys have been generated'
else
    echo 'keys are already sets'
fi

# Starting fpm service
service php8.3-fpm start
echo 'Starting nginx and php-fpm ...'

# This will execute any arguments passed to the script, allowing you to still use CMD ["/bin/bash", "/usr/local/bin/start.sh"]
exec "$@"