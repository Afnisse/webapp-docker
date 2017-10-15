> Built for personal use only.

# What is Web-APP-Docker?
**webapp-docker** make it easy to run your website inside docker with just one click, for
both development and production.

# Installation
```
$ git clone https://github.com/OussamaElgoumri/webapp-docker.git my-app
$ cd my-app
$ ./install
```

once the installation is completed, open your browser and type `http://webapp-docker.dev`

[![asciicast](https://asciinema.org/a/142080.png)](https://asciinema.org/a/142080)

# Configuration
If you want to customize webapp-docker, then rename `.env.example` to `.env` and
edit the configuration.

By default webapp-docker comes with full support to laravel framework, but it can be
customized to support any framework, even custom websites.

## Add your website:
If you want to add your own website, follow these steps:

1. copy the source code to your website inside `website/src`
2. backup your .env file
3. remove .env file
3. copy the content of `/var/lib/mysql` of your mysql database inside `db/config/var-lib/mysql`
4. run `./install`

don't forget to add your custom configuration to the .env file inside `website/src`

that's it :)

## Configuration environment variables:
### APP_DEBUG
`default: true`

### APP_ENV
`default: development`

### APP_LOG_LEVEL
`default: debug`

### APP_NAME
Your application name

### APP_SCHEME
http or https

### APP_TYPE
`laravel` install a laravel application

### APP_DOMAIN
The domain of your application

### CACHE_PREFIX
used as a prefix for cache services like `redis`

### DB_CONNECTION
`mysql`, or the name of the connection you use on your web application

### DB_DATABASE
the name of your database

### DB_HOST
**DO NOT EDIT** will be updated automatically

### DB_USERNAME
the username of your database

### DB_PASSWORD
the password of your database

### DB_PORT
**DO NOT EDIT**

### REDIS_HOST
**DO NOT EDIT** will be updated automatically

### REDIS_PASSWORD
Redis password

### REDIS_PORT
**DO NOT EDIT**

### BROADCAST_DRIVER
`default: redis` your broadcast driver

### CACHE_DRIVER
`default: redis` your cache driver

### QUEUE_DRIVER
`default: redis` queue driver

### SESSION_DRIVER
`default: redis` session driver

### SESSION_LIFETIME
`default: redis` session lifetime

# How webapp-docker work?
on the host machine, webapp-docker install `apache2` and use it as a reverse proxy, and a
load balancer. it also uses `jq` to cleanly extract values from `docker inspect`
command.

`webapp-docker` use 3 official images from hub.docker.com:
1. mysql:5.7
2. redis:4
3. php:7.0-apache

webapp-docker will automatically use your `username` and id, to properly update /etc/passwd
of the guest machine, and set the permissions of the website directories and files
so you can just move on with your life, with no problem's :)

* To set php.ini configuration you can edit eather php-development.ini or php-production.ini in website/config/php-\*.ini
* To update the virtual host of your website, please edit `website/config/000-default.conf`
* To update apache2.conf used on your website, please edit `website/config/apache2.conf`
* To change the user/id used on the website please edit `website/config/passwd`
* to change the php configuration for production or development please edit `website/config/php-development.ini` or `website/config/php-production.ini` for production

# Contribute
* support windows and mac
* add configuration variables for php version, mysql version and redis
* add support for other frameworks like wordpress, drupal..
* make it easy to migrate an existing website to webapp-docker
* improve development and production configuration
* allow developer to pick a revese proxy: nginx, apache2 or haproxy.
* add an option for sql script path, to import the sql dump, instead of copying /var/lib/mysql
