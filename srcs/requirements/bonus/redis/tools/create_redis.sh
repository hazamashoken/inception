if [ ! -d /var/run/redis ]; then
	mkdir -p /var/run
	mkdir -p /var/run/redis
fi

echo $REDIS_PASS

grep "requirepass foobared" /etc/redis/redis.conf > /dev/null

# Change redis password on first run
if [ $? -eq 0 ]; then
	sed -i "s/foobared/$REDIS_PASS/1" /etc/redis/redis.conf
fi

echo "Starting redis-server..."


# #!/bin/sh
# set -e

# # first arg is `-f` or `--some-option`
# # or first arg is `something.conf`
# if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
# 	set -- redis-server "$@"
# fi

# # allow the container to be started with `--user`
# if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
# 	find . \! -user redis -exec chown redis '{}' +
# 	exec su-exec redis "$0" "$@"
# fi

# # set an appropriate umask (if one isn't set already)
# # - https://github.com/docker-library/redis/issues/305
# # - https://github.com/redis/redis/blob/bb875603fb7ff3f9d19aad906bd45d7db98d9a39/utils/systemd-redis_server.service#L37
# um="$(umask)"
# if [ "$um" = '0022' ]; then
# 	umask 0077
# fi

# exec "$@"
