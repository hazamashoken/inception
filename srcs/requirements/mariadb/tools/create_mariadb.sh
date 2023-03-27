#!/bin/bash

echo Setting up database ...
rm -rf /var/lib/mysql
mkdir -p /var/lib/mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
mariadb-install-db --user-mysql --basedir=/usr --datadir=/var/lib/mysql

echo Running maridb server in the background ...
mariadb -u mysql --skip-networking &
mariadb_pid=$!

echo Removing Test database and anonymous user ...
mariadb -u root -e "
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.user WHERE User='';
"

echo Creating database
mariadb -u root -e "
CREATE DATABASE ${MYSQL_NAME}
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON '${MYSQL_NAME}'.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
"

echo Killing database
kill mariadb_pid
wait mariadb_pid

