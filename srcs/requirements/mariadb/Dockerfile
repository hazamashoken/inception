FROM debian:buster

RUN apt-get update && \
	apt-get install -y \
	mariadb-server \
	mariadb-client \
	&& rm -rf /var/lib/apt/list/*

RUN adduser mysql && \
	chown -R mysql:mysql /var/lib/mysql

COPY ./tools/create_mariadb.sh /usr/local/bin/

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/create_mariadb.sh"]

