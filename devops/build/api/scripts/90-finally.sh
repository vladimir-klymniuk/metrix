#!/usr/bin/env bash

##prepare symfony cache
php bin/console cache:warmup --env=$APP__ENV $APP__CONSOLE_OPTIONS

##clear application cache
php bin/console doctrine:mongodb:cache:clear-metadata --env=$APP__ENV $APP__CONSOLE_OPTIONS

#change permissions for cache dirs
if [ "$APP__CACHE_DIR" != "" ]; then
    chown -R www-data:www-data $APP__CACHE_DIR
else
    chown -R www-data:www-data /var/www/project/var/cache
fi

#change permissions for sessions & logs
chown -R www-data:www-data /var/www/project/var/log