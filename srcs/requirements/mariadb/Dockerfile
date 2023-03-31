FROM alpine:3.16

RUN apk update && \
	apk add mariadb mariadb-client

COPY conf/mariadb-server.conf /etc/my.cnf.d/maria-server.cnf

# COPY conf/mariadb.conf /etc/my.cnf.d/mariadb.cnf

COPY tools/create_mariadb.sh /tmp/

EXPOSE 3306

ENTRYPOINT sh /tmp/create_mariadb.sh ; mysqld -u mysql
