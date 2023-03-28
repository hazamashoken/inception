FROM debian:buster

RUN apt-get update && \
	apt-get -y install \
	libzip-dev \
	libpng-dev \
	libjpeg-dev \
	libfreetype6-dev \
	curl \
	unzip \
	php-fpm \
	php-mysql \
	redis \
	php-redis \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*


WORKDIR /var/www/html

COPY ./tools/create_wordpress.sh /usr/local/bin/

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp
RUN chmod +x /usr/local/bin/create_wordpress.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/create_wordpress.sh", ";", "/usr/sbin/php-fpm7.3", "-F"]
