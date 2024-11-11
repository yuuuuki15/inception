#!/bin/bash

mkdir /var/www/html

cd /var/www/html

rm -rf *

curl -O https://wordpress.org/latest.tar.gz

tar -xzf latest.tar.gz

rm -rf latest.tar.gz

mv wordpress/* .

rm -rf wordpress

mv /wp-config.php .

/usr/sbin/php-fpm7.3 -F
