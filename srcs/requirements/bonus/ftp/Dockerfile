FROM debian:buster

# Install ftp acl
RUN apt-get update; \
	apt-get install -y vsftpd acl

# Setting configuration in container
COPY conf/vsftpd.conf /etc/vsftpd.conf

# Clone launching file
COPY tools/create_ftp.sh /tmp/create_ftp.sh

ENTRYPOINT sh /tmp/create_ftp.sh
