#!/bin/bash

cleanup() {
    echo "Shutdown signal received. Shutting down MariaDB..."
    mysqladmin -u root shutdown
    exit 0
}
trap cleanup SIGTERM SIGINT

# service mariadb start

mysqld_safe &
MYSQL_PID=$!

# Wait for MariaDB to start
i=0
while ! mysqladmin ping -h localhost --silent; do
    echo "Waiting for MariaDB to start..."
    sleep 1
    i=$((i+1))
    if [ $i -eq 10 ]; then
        echo "MariaDB failed to start within 10 seconds. Exiting."
        exit 1
    fi
done

# Create database and user
mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF
# mysql -u root << EOF
# CREATE DATABASE IF NOT EXISTS wordpress;
# CREATE USER IF NOT EXISTS 'ykawakit'@'%' IDENTIFIED BY 'Kyuki-86340616';
# GRANT ALL PRIVILEGES ON wordpress.* TO 'ykawakit'@'%';
# FLUSH PRIVILEGES;
# EOF

# Import WordPress data
mysql -u root $MYSQL_DATABASE < /wordpress.sql
# mysql -u root wordpress < /wordpress.sql

# kill $(cat /var/run/mysqld/mysqld.pid)

# mysqld
wait $MYSQL_PID
