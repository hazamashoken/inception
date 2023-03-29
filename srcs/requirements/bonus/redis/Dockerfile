FROM debian:buster

# Install ftp acl
RUN apt-get update; \
	apt-get install -y redis-server

# Copy redis config
COPY conf/redis.conf /etc/redis/redis.conf

# Copy redis launcher
COPY tools/redis_launcher.sh /tmp/redis_launcher.sh

ENTRYPOINT sh /tmp/redis_launcher.sh
