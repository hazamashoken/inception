FROM alpine:3.16

RUN apk add --no-cache redis

RUN mkdir -p /etc/redis

COPY conf/redis.conf /etc/redis/

COPY tools/create_redis.sh /tmp/

EXPOSE 6379

ENTRYPOINT sh /tmp/create_redis.sh
