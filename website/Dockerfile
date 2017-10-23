FROM php:7.0-apache

MAINTAINER Oussama Elgoumri <ktsnepyg9igfz1@gmail.com>

WORKDIR /var/www/html

# ------------------------------------------------------ Install utilities --
RUN apt update && apt upgrade -y \
    && apt install git zip unzip zlib1g-dev libicu-dev -y --no-install-recommends \
    && rm -r /var/lib/apt/lists/*

# ------------------------------------------------------- Install composer --
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

# ----------------------------------------------------- Install extensions --
RUN pecl install redis \
    && docker-php-ext-enable redis \
    && docker-php-ext-install pdo pdo_mysql zip intl

# ----------------------------------------- Install development extensions --
RUN if [ $APP_ENV = 'development' ]; then \
        pecl install xdebug \
        docker-php-ext-enable xdebug \
    fi

# ---------------------------------------------------------- Configuration --
RUN for m in autoindex deflate expires filter headers include mime rewrite setenvif \
    do a2enmod $m \
    done
