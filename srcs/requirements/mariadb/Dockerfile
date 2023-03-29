FROM debian:buster

RUN apt-get update && \
	apt-get install -y \
	mariadb-server \
	mariadb-client \
	&& rm -rf /var/lib/apt/list/*

RUN adduser mysql; \
	chown -R mysql /var/lib/mysql;

COPY ./tools/create_mariadb.sh /tmp/
COPY conf/database.conf /tmp/database.conf
COPY conf/mariadb.conf /etc/mysql/mariadb.conf
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN chmod +x /usr/local/bin/create_mariadb.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/create_mariadb.sh"]
