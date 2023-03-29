# Create user on first time
if [ ! -d "/home/$FTP_USER" ]; then
	mkdir -p /home/$FTP_USER
	# Add new user and add it to frp group
	adduser --disabled-password --gecos "" --no-create-home --home /home/$FTP_USER --ingroup $FTP_GROUP $FTP_USER
	echo "$FTP_USER:$FTP_PASS" | chpasswd
	# Create home directory for ftp user
	chown $FTP_USER:$FTP_GROUP /home/$FTP_USER
	# Create secure_chroot_dir
	mkdir -p /var/run/vsftpd
	mkdir -p /var/run/vsftpd/empty
	# Add wordpress user to chroot_list
	echo "$FTP_USER" | tee -a /etc/vsftpd.chroot_list > /dev/null
	# Set user access to /var/www/inception
	setfacl -m u:$FTP_USER:r-x /var/www/
	setfacl -R -m u:$FTP_USER:rwx /var/www/inception
	setfacl -R -d -m u:$FTP_USER:rwx /var/www/inception
fi

echo "Starting FTP server..."
/usr/sbin/vsftpd
