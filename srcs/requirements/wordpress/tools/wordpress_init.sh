#!/bin/bash
set -e
cd /var/www/

if [ ! -f /var/www/html/index.php ]; then
    echo "WordPress files not found, downloading..."
    wp core download --allow-root
    chown -R www-data:www-data /var/www/html
fi

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Waiting for MariaDB..."
    until mariadb-admin -h mariadb -u $MARIADB_USER -p"$MARIADB_PASSWORD" ping -s ; do
        sleep 1
    done
    
    echo "Creating wp-config.php..."
    wp config create \
        --dbname=$MARIADB_DATABASE \
        --dbuser=$MARIADB_USER \
        --dbpass=$MARIADB_PASSWORD \
        --dbhost=mariadb \
        --allow-root
    
    echo "Installing WordPress..."
    wp core install \
        --url=$WP_WEBSITE_URL \
        --title=$WP_WEBSITE_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email \
        --allow-root
    
    echo "Creating WordPress user..."
    wp user create \
        $WP_USER \
        $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=author \
        --allow-root
fi

echo "Starting PHP-FPM..."
exec php-fpm7.4 -F