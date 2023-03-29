FROM debian:buster

# Install ftp acl
RUN apt-get update; \
	apt-get install -y vsftpd acl

# Setting configuration in container
COPY conf/vsftpd.conf /etc/vsftpd.conf

# Clone launching file
COPY tools/ftp_launcher.sh /tmp/ftp_launcher.sh

ENTRYPOINT sh /tmp/ftp_launcher.sh
