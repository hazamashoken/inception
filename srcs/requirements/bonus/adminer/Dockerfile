# install adminer here
# same vol as wordpress
# cp it in /var/www/html

FROM alpine:3.16

RUN apk update && \
	apk add wget

WORKDIR /var/www/html

RUN wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" --quiet -O adminer.php
