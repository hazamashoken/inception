#!/bin/bash

echo Setting up database ...
rm -rf /var/lib/mysql
mkdir -p /var/lib/mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

echo Running maridb server in the background ...
mysqld -u mysql --skip-networking --initialize-insecure &
service mysql start

echo Remove test Database
mysql -u root -e "DROP DATABASE IF EXISTS test;"

echo Remove anonymous users
mysql -u root -e "DELETE FROM mysql.user WHERE User='';"

echo Remove remote root access
mariadb -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"

echo Creating database
echo "CREATE DATABASE ${MYSQL_NAME}"
mysql -u root -e "CREATE DATABASE ${MYSQL_NAME}"

echo Creating user
echo "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -u root -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

echo Grant user privileges
echo "GRANT ALL PRIVILEGES ON '${MYSQL_NAME}'.* TO '${MYSQL_USER}'@'%';"
mysql -u root -e "GRANT ALL PRIVILEGES ON '${MYSQL_NAME}'.* TO '${MYSQL_USER}'@'%';"

echo Flush privileges
mysql -u root -e "FLUSH PRIVILEGES;"

echo Change root password
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

echo stoping mariadb server
service mysql stop

