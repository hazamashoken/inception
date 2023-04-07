FROM alpine:3.16

RUN apk update && \
	apk add mariadb mariadb-client mariadb-server-utils && \
	rm -f /var/cache/apk/*

ADD tools/create_mariadb.sh /scripts/create_mariadb.sh

RUN chmod -R 755 /scripts

# COPY conf/mariadb-server.conf /etc/my.cnf.d/maria-server.cnf

# COPY conf/mariadb.conf /etc/my.cnf.d/mariadb.cnf


EXPOSE 3306

ENTRYPOINT /scripts/create_mariadb.sh ;

RUN echo "Starting mariadb server..."
