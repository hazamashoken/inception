FROM alpine:3.16

# Install ftp acl
RUN apk update && \
	apk add redis

# Copy redis config
COPY conf/redis.conf /etc/redis/redis.conf

# Copy redis launcher
COPY tools/create_redis.sh /tmp/create_redis.sh

EXPOSE 6379

ENTRYPOINT sh /tmp/create_redis.sh
