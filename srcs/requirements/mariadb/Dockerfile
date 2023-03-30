FROM debian:buster

RUN apt-get -y update && \
	apt-get -y install mariadb-server mariadb-client

RUN adduser mysql ; \
	chown -R mysql:mysql /var/lib/mysql

COPY conf/mariadb-server.cnf /etc/mysql/mariadb.conf.d/maria-server.cnf

COPY conf/mariadb.conf /etc/mysql/mariadb.cnf

COPY tools/create_mariadb.sh /tmp/

EXPOSE 3306

ENTRYPOINT sh /tmp/create_mariadb.sh
