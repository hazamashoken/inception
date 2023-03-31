FROM alpine:3.16

RUN	apk update && \
	apk add --no-cache \
	vsftpd

COPY conf/vsftpd.conf /tmp/vsftpd.conf

COPY tools/configure.sh /tmp/configure.sh

ENTRYPOINT ["sh", "/tmp/configure.sh"]
