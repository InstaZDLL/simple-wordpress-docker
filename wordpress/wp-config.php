<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/documentation/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wpuser' );

/** Database password */
define( 'DB_PASSWORD', 'wpuser' );

/** Database hostname */
define( 'DB_HOST', '172.17.0.2' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '3LlP8qwOMWAATzTb2o1ym7ltMKPynqUfwDNO9G9BXo8=' );
define( 'SECURE_AUTH_KEY',  'xsERuyw8uPB5jQ1IKjzF6WFv4fGvyVagMiLC/vYD0Ks=' );
define( 'LOGGED_IN_KEY',    'KzrMbeUgQ+90hwEegJzZ2lgxjhgAnKhmC3lhTEcNgWI=' );
define( 'NONCE_KEY',        'Ul2uSZZrDsdV+PFVfSsDXoO4vNMydHM7m9JWrgnQkps=' );
define( 'AUTH_SALT',        'XFiusW5jBICOIkmm2WxSTBJNSUz+aASxhizFCMSO5Gg=' );
define( 'SECURE_AUTH_SALT', 'ZnZTXeMd2oDFBIkeL/LkHZRcTuOVAiRsE3xggU8RJQs=' );
define( 'LOGGED_IN_SALT',   '4U830qNpnVrvvV+kf++ArYYQkxRqXP4dvC7oCdzBKL4=' );
define( 'NONCE_SALT',       'mz+5tILW1GKMGoPPwfS2f2Sp5OafOAyal6K5GZv+LV4=' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/documentation/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
