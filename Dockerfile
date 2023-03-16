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
    sed -i 's#/var/www/localhost#/var/www/html#g' /etc/apache2/httpd.conf && \
    if [ "${WEB_SERVER}" = "apache2" ]; then \
        apk add php${PHP_VERSION//./}-${WEB_SERVER}; \
        chown apache:apache /var/www/html/; \
        sed -i 's/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/g' /etc/apache2/httpd.conf;  \
    fi; \
    if [ "${WEB_SERVER}" = "nginx" ]; then \
        sed -i 's/user nginx;/user root;/' /etc/nginx/nginx.conf; \
#        sed -i 's/worker_processes  auto;/worker_processes  1;/' /etc/nginx/nginx.conf; \
#        sed -i 's#root /var/www/html;#root /var/www/html;\n\tindex index.php;#' /etc/nginx/http.d/default.conf; \
#        sed -i 's/#location \~ \\\.php\$/location \~ \\\.php\$/' /etc/nginx/http.d/default.conf; \
#        sed -i 's/#\tfastcgi_pass unix:\/run\/php\/php8.1-fpm.sock;/\tfastcgi_pass unix:\/run\/php\/php${PHP_VERSION}-fpm.sock;/' /etc/nginx/http.d/default.conf; \
#        chown -R nginx:nginx /var/www/html; \
#        sed -i 's#root   /var/www/localhost/htdocs;#root   /var/www/html;#' /etc/nginx/conf.d/default.conf; \
#        sed -i 's/user nginx;/user root;/' /etc/nginx/nginx.conf; \
#        sed -i 's/worker_processes  auto;/worker_processes  1;/' /etc/nginx/nginx.conf; \
#        ln -s /dev/stdout /var/log/nginx/access.log; \
#        ln -s /dev/stderr /var/log/nginx/error.log; \
    fi

# Set the working directory to /var/www/localhost/htdocs
WORKDIR /var/www/html

#VOLUME ./htdocs /var/www/localhost/htdocs
# Copy the current directory contents into the container at /var/www/localhost/htdocs
#COPY ./htdocs /var/www/localhost/htdocs

# Expose port 80 for Apache/Nginx
EXPOSE 80

# Copy start script
COPY inc/start-${WEB_SERVER}.sh /opt/start.sh
RUN chmod +x /opt/start.sh

CMD /opt/start.sh
