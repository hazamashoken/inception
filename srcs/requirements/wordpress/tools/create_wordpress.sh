#!/bin/bash
echo Checking if wordpress ins installed
if [ -f "index.php" ]
	exit 0
fi


echo creating database ...
mariadb -u root -e "SELECT version();" > /dev/null 2>&1
while [ "$?" != "0" ]
do
	sleep 1
	mariadb -u root -e "SELECT version();" > /dev/null 2>&1
done

wp core download --path=`/var/www/html`

wp config create --dbname=$MY_SQL_DATABASE \
	--dbuser=$MYSQL_USER \
	--dbpass=$MYSQL_PASSWORD \
	--dbhost=$MYSQL_HOSTNAME \
	--force


wp core install
