FROM alpine:3.17.2

# Define args that came from Makefile
ARG PHP_VERSION
ARG WEB_SERVER

# Install packages
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk --update --no-cache add \
                           ${WEB_SERVER} && \
    mkdir -p /var/www/html/htdocs

COPY inc/etc/nginx/http.d/default.conf /etc/nginx/http.d/default.conf

RUN  if [ "${WEB_SERVER}" = "nginx" ]; then \
        sed -i 's/user nginx;/user root;/' /etc/nginx/nginx.conf && \
	sed -i "s/_PHP-VERSION_/${PHP_VERSION//./}/g" /etc/nginx/http.d/default.conf; \
    fi

# Set the working directory to /var/www/localhost/htdocs
WORKDIR /var/www/html

# Expose port 80 for Apache/Nginx
EXPOSE 80

# Copy start script
COPY inc/opt/start-${WEB_SERVER}.sh /opt/start.sh
RUN chmod +x /opt/start.sh

CMD /opt/start.sh
