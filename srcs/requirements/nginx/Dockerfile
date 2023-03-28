FROM debian:buster

RUN apt-get update && \
	apt-get install -y nginx openssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt \
	-subj "/C=TH/ST=Bangkok/O=42Bangkok/OU=42Bangkok/CN=tliangso.42.fr"

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
