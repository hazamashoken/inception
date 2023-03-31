# if [ ! -d /var/lib/mysql/wordpress ]; then
#   echo Install database with correct permissions
#   rm -rf /var/lib/mysql
#   mkdir -p /var/lib/mysql /var/run/mysqld
#   chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
#   chmod -R 755 /var/run/mysqld
#   mariadb-install-db --user=$MYSQL_USER --basedir=/usr --datadir=/var/lib/mysql

#   echo Start mariadb
#   mariadbd -u mysql --skip-networking &
#   mariadbd_pid=$!

#   echo Wait until database is ready
#   mariadb -u root -e "SELECT version();" > /dev/null 2>&1
#   while [ "$?" != "0" ]
#   do
#     sleep 1
#     mariadb -u root -e "SELECT version();" > /dev/null 2>&1
#   done

#   echo Disable anonymous user
#   mariadb -u root -e "DELETE FROM mysql.user WHERE User='';"

#   echo Disable remote root
#   mariadb -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"

#   echo Remove test database
#   mariadb -u root -e "DROP DATABASE IF EXISTS test;"

#   echo Create new database
#   echo "CREATE DATABASE $MYSQL_NAME;"
#   mariadb -u root -e "CREATE DATABASE $MYSQL_NAME;"

#   echo Create extra mariadb user
#   echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
#   mariadb -u root -e "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

#   echo Give access to extra user
#   echo "GRANT ALL ON $MYSQL_NAME.* TO '$MYSQL_USER'@'%';"
#   mariadb -u root -e "GRANT ALL ON $MYSQL_NAME.* TO '$MYSQL_USER'@'%';"

#   echo Set the root password
#   echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOTPASSWORD'; FLUSH PRIVILEGES;"
#   mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOTPASSWORD'; FLUSH PRIVILEGES;"

#   echo Stop mariadb
#   kill $mariadbd_pid
#   wait $mariadbd_pid

# fi

if [ -d "/run/mysqld" ]; then
	echo "[i] mysqld already present, skipping creation"
	chown -R mysql:mysql /run/mysqld
else
	echo "[i] mysqld not found, creating...."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ -d /var/lib/mysql/mysql ]; then
	echo "[i] MySQL directory already present, skipping creation"
	chown -R mysql:mysql /var/lib/mysql
else
	echo "[i] MySQL data directory not found, creating initial DBs"

	chown -R mysql:mysql /var/lib/mysql

	mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

	if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
		MYSQL_ROOT_PASSWORD=`pwgen 16 1`
		echo "[i] MySQL root Password: $MYSQL_ROOT_PASSWORD"
	fi

	MYSQL_DATABASE=${MYSQL_DATABASE:-""}
	MYSQL_USER=${MYSQL_USER:-""}
	MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
	    return 1
	fi

	cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOF


	if [ "$MYSQL_DATABASE" != "" ]; then
	    echo "[i] Creating database: $MYSQL_DATABASE"
		if [ "$MYSQL_CHARSET" != "" ] && [ "$MYSQL_COLLATION" != "" ]; then
			echo "[i] with character set [$MYSQL_CHARSET] and collation [$MYSQL_COLLATION]"
			echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET $MYSQL_CHARSET COLLATE $MYSQL_COLLATION;" >> $tfile
		else
			echo "[i] with character set: 'utf8' and collation: 'utf8_general_ci'"
			echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile
		fi

		if [ "$MYSQL_USER" != "" ]; then
			echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
			echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
		fi
	fi

	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < $tfile
	rm -f $tfile

    # only run if we have a starting MYSQL_DATABASE env variable AND
    # the /docker-entrypoint-initdb.d/ file is not empty
	if [ "$MYSQL_DATABASE" != "" ] && [ "$(ls -A /docker-entrypoint-initdb.d 2>/dev/null)" ]; then

		# start the server temporarily so that we can import seed files
        echo
        echo "Preparing to process the contents of /docker-entrypoint-initdb.d/"
        echo
		TEMP_OUTPUT_LOG=/tmp/mysqld_output
		/usr/bin/mysqld --user=mysql --skip-name-resolve --skip-networking=0 --silent-startup > "${TEMP_OUTPUT_LOG}" 2>&1 &
		PID="$!"

		# watch the output log until the server is running
		until tail "${TEMP_OUTPUT_LOG}" | grep -q "Version:"; do
			sleep 0.2
		done

    	# send the temporary mysqld server a shutdown signal
        # and wait till it's done before completeing the init process
    	kill -s TERM "${PID}"
    	wait "${PID}"
        rm -f TEMP_OUTPUT_LOG
    	echo "Completed processing seed files."
	fi;

	echo
	echo 'MySQL init process done. Ready for start up.'
	echo

	echo "exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0" "$@"
fi

exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0 $@
