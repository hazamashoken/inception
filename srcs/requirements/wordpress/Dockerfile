FROM debian:buster

RUN apt-get update && \
	apt-get -y install \
	libzip-dev \
	libpng-dev \
	libjpeg-dev \
	libfreetype6-dev \
	wget \
	unzip \
	php-fpm \
	php-mysql \
	wp-cli \
	redis-server \
	php-redis \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*


WORKDIR /var/www/html

COPY ./tools/create_wordpress.sh /usr/local/bin/

RUN wget https://wordpress.org/latest.tar.gz && \
	tar -zxf lastest.tar.gz && \
	rm latest.tar.gz && \
	chown -R www.data:www-data /var/www/inception && \
	chmod +X /usr/local/bin/create_wordpress.sh

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d

ENTRYPOINT ["/usr/local/bin/create_wordpress.sh"]

EXPOSE 9000

CMD ["/usr/sbin/php-fpm7.3", "-F"]
