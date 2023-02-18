
# Include environment variables from env.mak file if it exists
ifneq ($(wildcard env.mak),)
    include env.mak
endif

# Set a default value for the PHP version if not defined
PHP_VERSION ?= 8.2
WEB_SERVER ?= apache2
IMAGE_NAME ?= $(WEB_SERVER)_php-$(PHP_VERSION)
# Build the Docker image with the PHP version specified in the environment
build:
	docker build \
          --build-arg PHP_VERSION=$(subst .,,$(PHP_VERSION)) \
          --build-arg WEB_SERVER=$(WEB_SERVER)  \
          -t $(IMAGE_NAME) .

# Clean up the Docker image
clean:
	docker rmi $(IMAGE_NAME)

# Default target is to build the Docker image with the default PHP version
.DEFAULT_GOAL := build

