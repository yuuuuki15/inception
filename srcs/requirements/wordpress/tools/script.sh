#!/bin/bash

cleanup() {
    echo "Shutdown signal received. Shutting down WordPress..."
    exit 0
}
trap cleanup SIGTERM SIGINT

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar

mv wp-cli.phar /usr/local/bin/wp

if [ -f /var/www/html/wp-config.php ]; then
    echo "WordPress is already installed. Skipping installation."
else
    mkdir -p /var/www/html

    cd /var/www/html

    rm -rf *

    curl -o wordpress.tar.gz https://wordpress.org/wordpress-6.7.1.tar.gz

    # tar -xvf wordpress.tar.gz
    tar -xvf wordpress.tar.gz --strip-components=1 -C .

    rm -rf wordpress.tar.gz

    # mv wordpress/* .

    # rm -rf wordpress

    echo "Wordpress installed"

    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config.php
    sed -i "s/username_here/$MYSQL_USER/g" wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config.php
    sed -i "s/localhost/mariadb/g" wp-config.php

    if ! grep -q "WP_REDIS_HOST" wp-config.php; then
        sed -i '/DB_COLLATE/a define( '\''WP_REDIS_HOST'\'', '\''redis'\'' );' wp-config.php
        sed -i '/DB_COLLATE/a define( '\''WP_REDIS_PORT'\'', 6379 );' wp-config.php
        sed -i '/DB_COLLATE/a define('\''WP_CACHE'\'', true);' wp-config.php
        sed -i '/DB_COLLATE/a define('\''FS_METHOD'\'', '\''direct'\'');' wp-config.php
    fi

    echo "Wordpress configured"

    wp plugin install redis-cache --activate --allow-root
    wp plugin install wp-file-manager --activate --allow-root

    wp plugin update --all --allow-root

    wp redis enable --allow-root
fi

/usr/sbin/php-fpm7.4 -R -F &
PHP_PID=$!

wait $PHP_PID
