if [ ! -f "/etc/vsftpd/vsftpd.conf.bak" ]; then

    mkdir -p /var/www/html

    cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak
    mv /tmp/vsftpd.conf /etc/vsftpd/vsftpd.conf

    # Add the FTP_USER, change his password and declare him as the owner of wordpress folder and all subfolders

	echo Adding FTP user $FTP_USER
    adduser $FTP_USER --disabled-password
    echo "$FTP_USER:$FTP_PASS" | /usr/sbin/chpasswd &> /dev/null
	echo "$FTP_USER:$FTP_PASS"
    chown -R $FTP_USER:$FTP_USER /var/www/html

    echo $FTP_USER | tee -a /etc/vsftpd.userlist &> /dev/null

fi

echo "FTP started on 20:21:13450-13500"

