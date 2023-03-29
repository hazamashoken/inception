# Help on 1st launch with existed volume
if [ ! -d "/var/run/mysqld" ]; then
	mkdir -p /var/run/mysqld
	chown -R mysql:mysql /var/run/mysqld
fi

if [ ! -d "/var/run/mariadbd" ]; then
	mkdir -p /var/run/mariadbd
	chown -R mysql:mysql /var/run/mariadbd
fi

# Check if volume database exist or not
if [ ! -d /var/lib/mysql/wordpress ]; then
	# Init database
	mariadbd -u mysql --initialize-insecure
	service mysql start
	# Create WP database and user
	sed "s/MYSQL_USER/$MYSQL_USER/g" /tmp/database.conf \
	| sed -e "s/MYSQL_PASSWORD/$MYSQL_PASSWORD/g" \
	| sed -e "s/MYSQL_ROOTPASSWORD/$MYSQL_ROOTPASSWORD/g" | mysql --user=root ;
	service mysql stop
fi

mariadbd -u mysql
