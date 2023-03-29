# Connect to DB
while ! mariadb --host=$DB_HOST --user=$MYSQL_USER --password=$MYSQL_PASSWORD --port=3306 $DB_NAME; do
	echo "Try to reconnect to mariadb-server";
	sleep 10;
done
echo "Connected to mariadb-server"

# Check if wordpress is already exist
if [ ! -f wp-config.php ]; then
	wp core download --allow-root
	wp config create --dbhost=$DB_HOST --dbname=$DB_NAME --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --allow-root
	wp core install --url=$WP_ADDRESS --title=$WP_TITLE --admin_name=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
	wp user create $WP_USER $WP_USER_EMAIL --role=author --user_pass=$WP_USER_PASSWORD --allow-root --quiet
	# Set up wp config for redis
	wp config set WP_REDIS_HOST "redis" --allow-root --quiet
	wp config set WP_REDIS_PORT "6379" --allow-root --quiet
	wp config set WP_REDIS_PASSWORD "$REDIS_PASS" --allow-root --quiet
	wp config set WP_REDIS_TIMEOUT "1" --allow-root --quiet
	wp config set WP_REDIS_READ_TIMEOUT "1" --allow-root --quiet
	wp config set WP_REDIS_DATABASE "0" --allow-root --quiet
	# Install redis plugin
	wp plugin install redis-cache --activate --allow-root --quiet
	# Enable redis plugin
	wp redis enable --allow-root --quiet
	# Install adminer
	wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" --quiet -O adminer.php
	# Move html content
	mv /tmp/contents /var/www/inception/hello_world
	mv /var/www/inception/rubber_duck/index.html /var/www/inception/index.html
fi

chown -R www-data:www-data /var/www/html

# Create socket directory
if [ ! -d /run/php ]; then
	mkdir -p /run
	mkdir -p /run/php
fi

echo "Starting php-fpm server..."
/usr/sbin/php-fpm7.3 -F -R
