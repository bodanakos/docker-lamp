
# Include environment variables from env.mak file if it exists
ifneq ($(wildcard env.mak),)
    include env.mak
endif

# Set a default value for the PHP version if not defined
PHP_VERSION ?= 8.2
WEB_SERVER ?= apache2
DB_BACKEND ?= mysql
DB_VERSION ?= 8.0

ifeq ($(DB_BACKEND),mariadb)
 DB_VERSION ?= 10.11
endif

DB_IMAGE_NAME ?= db_$(DB_BACKEND)-$(DB_VERSION)
WEB_IMAGE_NAME ?= $(WEB_SERVER)_php-$(PHP_VERSION)
PHP_IMAGE_NAME ?= php-$(PHP_VERSION)
NETWORK_NAME ?= webapp
# Build the Docker image with the PHP version specified in the environment
#           --build-arg PHP_VERSION=$(subst .,,$(PHP_VERSION)) \


build-web:
	docker build \
          --build-arg PHP_VERSION=$(PHP_VERSION) \
          --build-arg WEB_SERVER=$(WEB_SERVER)  \
          -t $(WEB_IMAGE_NAME) dockerfiles/web/$(WEB_SERVER)/

build-php:
	docker build \
          --build-arg PHP_VERSION=$(PHP_VERSION) \
          --build-arg WEB_SERVER=$(WEB_SERVER)  \
          -t php-$(PHP_VERSION) dockerfiles/php/
build-db:
	docker build \
	  --build-arg DB_BACKEND=$(DB_BACKEND) \
	  --build-arg DB_VERSION=$(DB_VERSION) \
	  -t db_$(DB_BACKEND)-$(DB_VERSION) dockerfiles/db/


create-network:
	docker network inspect $(NETWORK_NAME) >/dev/null 2>&1 || docker network create --driver bridge $(NETWORK_NAME)

run-web:
	$(MAKE) create-network && \
        docker run \
          -d \
          -p 80:80 \
	  --network $(NETWORK_NAME) \
          -v $(shell pwd)/sources/htdocs:/var/www/html/htdocs \
	$(WEB_IMAGE_NAME)

run-php:
	$(MAKE) create-network && \
	docker run \
	  --name php$(subst .,,$(PHP_VERSION))-fpm \
	  -d \
	  -p 9000:9000 \
	  --network $(NETWORK_NAME) \
	  -v $(shell pwd)/sources/htdocs:/var/www/html/htdocs \
	$(PHP_IMAGE_NAME)

run-db:
	$(MAKE) create-network && \
	docker run \
	  -v $(shell pwd)/sources/db:/var/db_dumps \
	$(DB_IMAGE_NAME)


run: run-web run-php run-db

build: build-web build-php build-db


# Clean up the Docker image
clean:
	docker rmi $(WEB_IMAGE_NAME) $(PHP_IMAGE_NAME)

# Default target is to build the Docker image with the default PHP version
.DEFAULT_GOAL := build
