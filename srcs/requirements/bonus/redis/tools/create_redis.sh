if [ ! -d /var/run/redis ]; then
	mkdir -p /var/run
	mkdir -p /var/run/redis
fi

grep "requirepass foobared" /etc/redis/redis.conf > /dev/null

# Change redis password on first run
if [ $? -eq 0 ]; then
	sed -i "s/foobared/$REDIS_PASS/1" /etc/redis/redis.conf
fi

echo "Starting redis-server..."
/usr/bin/redis-server /etc/redis/redis.conf
