FROM debian:bullseye-slim

RUN set -eux && \
    apt-get update -yq && \
	DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils ksh apache2 libapache2-mod-php && \
	a2enmod ssl && \
    a2enmod headers && \
	a2enmod rewrite expires && \
    a2enmod remoteip; \
	{ \
		echo 'RemoteIPHeader X-Forwarded-For'; \
		echo 'RemoteIPTrustedProxy 10.0.0.0/8'; \
		echo 'RemoteIPTrustedProxy 172.16.0.0/12'; \
		echo 'RemoteIPTrustedProxy 192.168.0.0/16'; \
		echo 'RemoteIPTrustedProxy 169.254.0.0/16'; \
		echo 'RemoteIPTrustedProxy 127.0.0.0/8'; \
	} > /etc/apache2/conf-available/remoteip.conf; \
	a2enconf remoteip; \    
	a2enmod proxy && \
	a2enmod proxy_http && \
	a2enmod proxy_balancer && \
	a2enmod lbmethod_byrequests && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq php php-xml php-mbstring && \
	DEBIAN_FRONTEND=noninteractive apt-get install -yq php-curl php-gd php-intl php-bz2 php-ldap && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq php-zip php-mysql php-pgsql 
	
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_RUN_DIR /var/www/html

	# logs should go to stdout / stderr		
RUN ln -sfT /dev/stderr "$APACHE_LOG_DIR/error.log"; \
	ln -sfT /dev/stdout "$APACHE_LOG_DIR/access.log"; \
	ln -sfT /dev/stdout "$APACHE_LOG_DIR/other_vhosts_access.log"; \
	chown -R --no-dereference "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$APACHE_LOG_DIR"

STOPSIGNAL SIGWINCH	

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

ENTRYPOINT ["/usr/sbin/apache2"]
CMD ["-D", "FOREGROUND"]