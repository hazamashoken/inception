FROM alpine:3.16

RUN apk update && \
	apk add mariadb mariadb-client mariadb-server-utils && \
	rm -f /var/cache/apk/*

ADD tools/create_mariadb.sh /scripts/create_mariadb.sh

RUN chmod -R 755 /scripts

ENTRYPOINT /scripts/create_mariadb.sh ;

EXPOSE 3306

RUN echo "Starting mariadb server..."
