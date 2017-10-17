#!/bin/bash

set -e

echo ----------------------------------------------------- Populate .env file --
sed -i "s/%APP_NAME%/${X_APP_NAME}/" .env
sed -i "s/%APP_ENV%/${X_APP_ENV}/" .env
sed -i "s/%APP_DEBUG%/${X_APP_DEBUG}/" .env
sed -i "s/%APP_LOG_LEVEL%/${X_APP_LOG_LEVEL}/" .env
sed -i "s~%APP_URL%~${X_APP_URL}~" .env
sed -i "s/%DB_CONNECTION%/${X_DB_CONNECTION}/" .env
sed -i "s/%DB_HOST%/${X_DB_HOST}/" .env
sed -i "s/%DB_PORT%/${X_DB_PORT}/" .env
sed -i "s/%DB_DATABASE%/${X_DB_DATABASE}/" .env
sed -i "s/%DB_USERNAME%/${X_DB_USERNAME}/" .env
sed -i "s/%DB_PASSWORD%/${X_DB_PASSWORD}/" .env
sed -i "s/%BROADCAST_DRIVER%/${X_BROADCAST_DRIVER}/" .env
sed -i "s/%CACHE_DRIVER%/${X_CACHE_DRIVER}/" .env
sed -i "s/%SESSION_DRIVER%/${X_SESSION_DRIVER}/" .env
sed -i "s/%SESSION_LIFETIME%/${X_SESSION_LIFETIME}/" .env
sed -i "s/%QUEUE_DRIVER%/${X_QUEUE_DRIVER}/" .env
sed -i "s/%REDIS_HOST%/${X_REDIS_HOST}/" .env
sed -i "s/%REDIS_PASSWORD%/${X_REDIS_PASSWORD}/" .env
sed -i "s/%REDIS_PORT%/${X_REDIS_PORT}/" .env

echo ----------------------------------------------- Edit configuration files --
sed -i "s/'client' => 'predis',/'client' => 'phpredis',/" config/database.php
sed -i "s/'prefix' => 'laravel',/'prefix' => '${CACHE_PREFIX}',/" config/cache.php

echo ------------------------------------------------------ Composer packages --
if [[ -d vendor ]]; then
    composer update
else
    composer install
fi

php artisan key:generate

echo ------------------------------------------------------------- Deployment --
if [ $X_APP_ENV = 'deployment' ]; then
    composer install --optimize-autoloader
    php artisan config:cache
    php artisan route:cache
fi

echo ------------------------------------------------------ Setup permissions --
find /var/www/html -type f -exec chmod 644 {} \;
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html/storage -type d -exec chmod 775 {} \;
find /var/www/html/storage -type f -exec chmod 664 {} \;
find /var/www/html/bootstrap/cache -type d -exec chmod 775 {} \;
find /var/www/html/bootstrap/cache -type f -exec chmod 664 {} \;

if [ ! -f storage/logs/laravel.log ]; then
    touch storage/logs/laravel.log
fi

chmod 664 storage/logs/laravel.log
chmod +x setup.sh

user=`tail -n1 /etc/passwd | cut -d':' -f1`
chown -R $user:www-data /var/www/html
chown -R $user:www-data /tmp/xdebug-profiler
