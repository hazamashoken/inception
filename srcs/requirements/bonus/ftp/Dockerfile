FROM alpine:3.16

RUN	apk update && \
	apk add --no-cache \
	vsftpd

COPY conf/vsftpd.conf /tmp/vsftpd.conf

COPY tools/configure.sh /tmp/configure.sh

EXPOSE 20 21 13450-13500

ENTRYPOINT sh /tmp/configure.sh ; /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
