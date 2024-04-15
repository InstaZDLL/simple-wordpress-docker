#!/bin/bash

# Use default values if the variables are not set
: "${WORDPRESS_COMPOSE:-false}"
: "${WORDPRESS_HOST:-localhost}"
: "${WORDPRESS_DATABASE_HOST:-localhost}"
: "${WORDPRESS_DATABASE:-wordpress}"
: "${WORDPRESS_DATABASE_USER:-wpuser}"
: "${WORDPRESS_DATABASE_PASSWORD:-wpuser}"

if [ "$WORDPRESS_COMPOSE" = "true" ]; then
    echo "[Info] The WORDPRESS_COMPOSE env bar is set to True"
    sleep 8
fi

if [ "$WORDPRESS_DATABASE_HOST" = "localhost" ]; then
    echo "[Warning] Database host is set to localhost"
    exit 1
fi

# Check if the WordPress directory is empty
if [ ! "$(ls -A /var/www/wordpress)" ]; then
   echo "WordPress directory is empty. Copying files..."
   cp -R /usr/src/wordpress/* /var/www/wordpress/
fi

if [ ! -f /docker-entrypoint-initdb.d/flagfile ]; then
    if [ "$WORDPRESS_HOST" = "localhost" ]; then
        echo -e '[Warning] The variable WORDPRESS_HOST has not been defined so all resources will only be available on localhost\nIf you want your wordpress to work online, change this variable'
    fi

    if [ "$WORDPRESS_HOST" = "localhost" ]; then
        echo 'Wordpress resources point to http://localhost'
        mysql -u ${WORDPRESS_DATABASE_USER} -p${WORDPRESS_DATABASE_PASSWORD} -h ${WORDPRESS_DATABASE_HOST} ${WORDPRESS_DATABASE} < /docker-entrypoint-initdb.d/init.sql
        echo '[Info] init.sql was imported into the designated database'
    else
        sed -i "s/http:\/\/localhost/http:\/\/${WORDPRESS_HOST}/g" /docker-entrypoint-initdb.d/init.sql
        mysql -u ${WORDPRESS_DATABASE_USER} -p${WORDPRESS_DATABASE_PASSWORD} -h ${WORDPRESS_DATABASE_HOST} ${WORDPRESS_DATABASE} < /docker-entrypoint-initdb.d/init.sql
        echo "The path of wordpress resources have changed, they point to http://${WORDPRESS_HOST}"
        echo '[Info] init.sql was imported into the designated database'
    fi

    touch /docker-entrypoint-initdb.d/flagfile
else
    echo 'the init.sql file has already been imported'
fi

if grep -q "put your unique phrase here" /var/www/wordpress/wp-config.php; then
    sed -i "s/database_name_here/${WORDPRESS_DATABASE}/g" /var/www/wordpress/wp-config.php
    sed -i "s/username_here/${WORDPRESS_DATABASE_USER}/g" /var/www/wordpress/wp-config.php
    sed -i "s/password_here/${WORDPRESS_DATABASE_PASSWORD}/g" /var/www/wordpress/wp-config.php
    sed -i "s/localhost/${WORDPRESS_DATABASE_HOST}/g" /var/www/wordpress/wp-config.php
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

# This will execute any arguments passed to the script, allowing you to still use CMD ["nginx", "-g", "daemon off;"]
exec "$@"
