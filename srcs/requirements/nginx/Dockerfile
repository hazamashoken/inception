FROM alpine:3.16

# Install nginx and openssl(for TLS)
RUN apk update; \
	apk add nginx \
	openssl

# Create certificates and key (Valid 365 day)
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt \
	# Fill prompt information
	-subj "/C=TH/ST=Bangkok/L=Bangkok/O=42Bangkok/OU=42Bangkok/CN=tliangso.42.fr"

# Copy config file
COPY conf/nginx.conf /etc/nginx/http.d/default.conf
# COPY conf/nginx.conf /etc/nginx/sites-available/inception

# remove later !!!!!!!!!!!!!!!
COPY contents /var/www/html

RUN mkdir -p /var/www/html && \
	chown -R nginx:nginx /var/www/html

RUN echo "Starting nginx server..."

# EXPOSE 443 80

ENTRYPOINT nginx -g 'daemon off;'
