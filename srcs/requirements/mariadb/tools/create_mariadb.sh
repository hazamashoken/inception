#!/bin/bash

echo Setting up database ...
rm -rf /var/lib/mysql
mkdir -p /var/lib/mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
mariadb-install-db --user-mysql --basedir=/usr --datadir=/var/lib/mysql

echo Running maridb server in the background ...
mariadb -u mysql --skip-networking &
mariadb_pid=$!

echo Remove test Database
mariadb -u root -e "DROP DATABASE IF EXISTS test;"
mariadb -u root -e "DELETE FROM mysql.user WHERE User='';"


echo Creating database
mariadb -u root -e "CREATE DATABASE ${MYSQL_NAME}"

echo Creating user
mariadb -u root -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

echo Grant user privileges
mariadb -u root -e "GRANT ALL PRIVILEGES ON '${MYSQL_NAME}'.* TO '${MYSQL_USER}'@'%';"

echo Flush privileges
mariadb -u root -e "FLUSH PRIVILEGES;"

echo Change root password
mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"


echo Killing database
kill mariadb_pid
wait mariadb_pid
