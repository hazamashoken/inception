#!/bin/bash

# Help on 1st launch with existed volume
if [ ! -d "/var/run/mysqld" ]; then
	mkdir -p /var/run/mysqld
	chown -R mysql:mysql /var/run/mysqld
fi

# Check if volume database exist or not
if [ ! -d /var/lib/mysql/wordpress ]; then
	# Init database
	mysqld -u mysql --initialize-insecure
	service mysql start
	# Create WP database and user
	sed "s/MYSQL_USER/$MYSQL_USER/g" /tmp/database.conf \
	| sed -e "s/MYSQL_PASSWORD/$MYSQL_PASSWORD/g" \
	| sed -e "s/MYSQL_ROOTPASSWORD/$MYSQL_ROOT_PASSWORD/g" | mysql --user=root ;
	service mysql stop
fi

mysqld -u mysql

# echo Setting up database ...
# rm -rf /var/lib/mysql
# mkdir -p /var/lib/mysql /var/run/mysqld
# chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
# mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# echo Running mariadb server in the background ...
# mysqld -u mysql --skip-networking --initialize-insecure
# service mysql start

# echo Waiting for mysql server to start ...
# mysql -u root -e "SELECT version();" > /dev/null 2>&1
# while [ "$?" != "0" ]
# do
# 	sleep 1
# 	mysql -u root -e "SELECT version();"
# done
# echo mysql server started


# echo Waiting for mariadb server to start ...
# mariadb -u root -e "SELECT version();" > /dev/null 2>&1
# while [ "$?" != "0" ]
# do
# 	sleep 1
# 	mariadb -u root -e "SELECT version();" > /dev/null 2>&1
# done

# echo Remove test Database
# mariadb -u root -e "DROP DATABASE IF EXISTS test;"

# echo Remove anonymous users
# mariadb -u root -e "DELETE FROM mysql.user WHERE User='';"

# echo Remove remote root access
# mariadb -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"

# echo Creating database
# echo "CREATE DATABASE ${MYSQL_NAME}"
# mariadb -u root -e "CREATE DATABASE ${MYSQL_NAME}"

# echo Creating user
# echo "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
# mariadb -u root -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# echo Grant user privileges
# echo "GRANT ALL PRIVILEGES ON '${MYSQL_NAME}'.* TO '${MYSQL_USER}'@'%';"
# mariadb -u root -e "GRANT ALL PRIVILEGES ON '${MYSQL_NAME}'.* TO '${MYSQL_USER}'@'%';"

# echo Flush privileges
# mariadb -u root -e "FLUSH PRIVILEGES;"

# echo Change root password
# echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
# mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

# echo stoping mariadb server
# service mysql stop

