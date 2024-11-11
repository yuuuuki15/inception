#!/bin/bash

service mariadb start

while ! mysqladmin ping -h localhost --silent; do
    sleep 1
done

mysql -u root < init.sql

service mariadb stop
