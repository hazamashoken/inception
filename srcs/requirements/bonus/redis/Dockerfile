FROM debian:buster

# Install ftp acl
RUN apt-get update; \
	apt-get -y upgrade && \
	apt-get install -y redis-server

# Copy redis config
COPY conf/redis.conf /etc/redis/redis.conf

# Copy redis launcher
COPY tools/create_redis.sh /tmp/create_redis.sh

EXPOSE 6379

ENTRYPOINT sh /tmp/create_redis.sh
