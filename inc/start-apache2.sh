#!/bin/sh

echo "***Starting apache2"
# Start nginx
/usr/sbin/httpd -D FOREGROUND;
