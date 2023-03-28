#!/bin/bash
echo Checking if wordpress ins installed
if [ -f "/var/www/html/index.php" ]
then
	echo Wordpress is already installed
	exit 0
fi


echo creating database ...
mariadb -u root -e "SELECT version();" > /dev/null 2>&1
while [ "$?" != "0" ]
do
	sleep 1
	mariadb -u root -e "SELECT version();" > /dev/null 2>&1
done

echo Downloading wordpress ...
wp core download --path=/var/www/html

echo Creating wp-config.php ...
wp config create --dbname=$MY_SQL_DATABASE \
	--dbuser=$MYSQL_USER \
	--dbpass=$MYSQL_PASSWORD \
	--dbhost=$MYSQL_HOSTNAME \
	--force

echo Installing wordpress ...
wp core install --url=$DOMAIN_NAME \
	--admin_user=$MYSQL_USER \
	--admin_email=$MYSQL_EMAIL \
	--admin_password=$MYSQL_PASSWORD \
	--title="Whatever"

echo Creating user ...
wp user create $WP_USER $WP_EMAIL --role=editor

echo Installing theme ...
wp theme install twentynineteen --activate

echo Installing plugin ...
wp redis enable

echo Setting up permissions ...
chown nginx:nginx /var/www/html
