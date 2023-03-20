ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm
RUN docker-php-ext-install mysqli && \
    docker-php-ext-enable mysqli
