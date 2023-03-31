echo Install database with correct permissions
rm -rf /var/lib/mysql
mkdir -p /var/lib/mysql /var/run/mysqld
ls -la /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
chmod -R 755 /var/run/mysqld
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

echo Start mariadb
mysqld -u mysql --skip-networking &
mariadbd_pid=$!

echo Wait until database is ready
mysql -u root -e "SELECT version();" > /dev/null 2>&1
while [ "$?" != "0" ]
do
  sleep 1
  mysql -u root -e "SELECT version();" > /dev/null 2>&1
done
ls -la /var/run/mysqld

echo Disable anonymous user
mysql -u root -e "DELETE FROM mysql.user WHERE User='';"

echo Disable remote root
mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"

echo Remove test database
mysql -u root -e "DROP DATABASE IF EXISTS test;"

echo Create new database
echo "CREATE DATABASE $MYSQL_NAME;"
mysql -u root -e "CREATE DATABASE $MYSQL_NAME;"

echo Create extra mariadb user
echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
mysql -u root -e "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

echo Give access to extra user
echo "GRANT ALL ON $MYSQL_NAME.* TO '$MYSQL_USER'@'%';"
mysql -u root -e "GRANT ALL ON $MYSQL_NAME.* TO '$MYSQL_USER'@'%';"

echo Set the root password
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOTPASSWORD'; FLUSH PRIVILEGES;"
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOTPASSWORD'; FLUSH PRIVILEGES;"

echo Stop mariadb
kill $mariadbd_pid
wait $mariadbd_pid
