FROM alpine:3.17.2

# Define args that came from Makefile
ARG PHP_VERSION
ARG WEB_SERVER

# Install packages
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk --update --no-cache add \
                           ${WEB_SERVER} \
                           php${PHP_VERSION//./}-gd \
                           php${PHP_VERSION//./}-mysqli \
                           php${PHP_VERSION//./}-pdo_mysql && \
    mkdir -p /var/www/html/htdocs && \
    if [ "${WEB_SERVER}" = "apache2" ]; then \
        sed -i 's#/var/www/localhost#/var/www/html#g' /etc/apache2/httpd.conf && \
        apk add php${PHP_VERSION//./}-${WEB_SERVER}; \
        chown apache:apache /var/www/html/; \
        sed -i 's/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/g' /etc/apache2/httpd.conf;  \
    fi;

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Expose port 80 for Apache
EXPOSE 80

# Copy start script
COPY inc/start-${WEB_SERVER}.sh /opt/start.sh
RUN chmod +x /opt/start.sh

CMD /opt/start.sh
