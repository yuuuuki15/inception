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

# Import WordPress data
if ! mysql -u root -e "USE $MYSQL_DATABASE" 2>/dev/null; then
    # Create database and user
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
    mysql -u root -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"
    mysql -u root -e "FLUSH PRIVILEGES;"

    mysql -u root $MYSQL_DATABASE < /wordpress.sql
fi

# mysqld
wait $MYSQL_PID
