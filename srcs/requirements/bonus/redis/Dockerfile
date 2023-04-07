FROM alpine:3.16

RUN apk update && \
	apk add --no-cache redis

RUN mkdir -p /etc/redis

COPY conf/redis.conf /etc/redis/

COPY tools/create_redis.sh /tmp/

# EXPOSE 6379

ENTRYPOINT redis-server --protected-mode no
