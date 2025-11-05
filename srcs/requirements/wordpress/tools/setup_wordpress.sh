#!/bin/bash

# Wait for MariaDB to be ready
sleep 10

# Create directory
mkdir -p /var/www/html
cd /var/www/html

# Download WP-CLI
if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Download WordPress if not exists
if [ ! -f wp-config.php ]; then
    wp core download --allow-root

    # Create wp-config.php
    wp config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb \
        --allow-root

    # Install WordPress
    wp core install \
        --url=${DOMAIN_NAME} \
        --title="Inception" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --allow-root

    # Create second user
    wp user create ${WP_USER} ${WP_USER_EMAIL} \
        --user_pass=${WP_USER_PASSWORD} \
        --role=author \
        --allow-root
fi

# Start PHP-FPM in foreground
mkdir -p /run/php
exec /usr/sbin/php-fpm7.4 -F