FROM debian:buster

# Install wordpress dependencies
RUN apt-get update; \
	# Install wget (Download wordpress-cli)
	apt-get install -y wget \
	# Install php (https://ubuntu.com/tutorials/install-and-configure-wordpress#2-install-dependencies)
	php7.3 \
	php7.3-curl \
	php7.3-imagick \
	php7.3-intl \
	php7.3-json \
	php7.3-mbstring \
	php7.3-mysql \
	php7.3-xml \
	php7.3-zip \
	php7.3-fpm \
	# Install mariadb-client use to connect to db server
	mariadb-client \
	# Install redis client
	redis

# Copy php-fpm.conf (Emergency restart & log level)
COPY conf/php-fpm.conf /etc/php/7.3/fpm/php-fpm.conf
# Copy www.conf (Listen to port 9000) to container
COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

# Download && install wordpress cli
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
	chmod +x wp-cli.phar; \
	mv wp-cli.phar /usr/local/bin/wp

# Create wordpress directory if it doesn't exist yet
RUN mkdir -p /var/www; \
	mkdir -p /var/www/html

# Change working directory to wordpress directory
WORKDIR /var/www/html

# Copy wordpress container launcher
COPY tools/create_wordpress.sh /tmp/create_wordpress.sh

# Copy html contents
ADD contents /tmp/contents

EXPOSE 9000

ENTRYPOINT sh /tmp/create_wordpress.sh
