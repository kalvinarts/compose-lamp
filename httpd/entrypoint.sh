#!/bin/bash

# Start php-fpm
service php7.0-fpm start
service php5-fpm start

# Run apache2ctl
/usr/sbin/apache2ctl -D FOREGROUND
