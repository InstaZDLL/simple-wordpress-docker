#!/bin/bash
#service nginx restart
#service php8.3-fpm restart
service php8.3-fpm start
nginx -g 'daemon off;'