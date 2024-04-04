#!/bin/bash

# If we are running as root
if [ "$(id -u)" = '0' ]; then
    # Use gosu to step down from root and run the rest of this script
    exec gosu www-data "$BASH_SOURCE" "$@"
fi

if grep -q "put your unique phrase here" /var/www/wordpress/wp-config.php; then
    sed -i "s/database_name_here/wordpress/g" /var/www/wordpress/wp-config.php
    sed -i "s/username_here/wpuser/g" /var/www/wordpress/wp-config.php
    sed -i "s/password_here/wpuser/g" /var/www/wordpress/wp-config.php
    sed -i "s|define( 'AUTH_KEY',         'put your unique phrase here' );|define( 'AUTH_KEY',         '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php
    sed -i "s|define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );|define( 'SECURE_AUTH_KEY',  '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php
    sed -i "s|define( 'LOGGED_IN_KEY',    'put your unique phrase here' );|define( 'LOGGED_IN_KEY',    '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php
    sed -i "s|define( 'NONCE_KEY',        'put your unique phrase here' );|define( 'NONCE_KEY',        '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php
    sed -i "s|define( 'AUTH_SALT',        'put your unique phrase here' );|define( 'AUTH_SALT',        '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php
    sed -i "s|define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );|define( 'SECURE_AUTH_SALT', '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php
    sed -i "s|define( 'LOGGED_IN_SALT',   'put your unique phrase here' );|define( 'LOGGED_IN_SALT',   '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php
    sed -i "s|define( 'NONCE_SALT',       'put your unique phrase here' );|define( 'NONCE_SALT',       '$(openssl rand -base64 32)' );|g" /var/www/wordpress/wp-config.php
fi

#service nginx restart
#service php8.3-fpm restart

# This will execute any arguments passed to the script, allowing you to still use CMD ["/bin/bash", "/usr/local/bin/start.sh"]
exec "$@"