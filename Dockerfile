FROM php:5.6-apache

MAINTAINER Milo van der Linden <milo@dogodigi.net>

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils\
       curl \
       git \
       libpq-dev \
       libmcrypt-dev \
       libpng12-dev \
       libjpeg62-turbo-dev \
       libfreetype6-dev \
       libxrender1 \
       libfontconfig \
       libxext-dev \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install -j$(nproc) pdo_pgsql pgsql mcrypt gd zip \
 && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Variables
ENV APP_ENV production
ENV APP_DEBUG false
ENV APP_URL http://localhost
ENV APP_CIPHER rijndael-128
ENV APP_KEY attendizeSecr3tK3y

ENV DB_TYPE mysql
ENV DB_HOST db
ENV DB_DATABASE attendize
ENV DB_USERNAME attendize
ENV DB_PASSWORD attendize
ENV WKHTML2PDF_BIN_FILE wkhtmltopdf-amd64
ENV MAIL_DRIVER smtp
ENV MAIL_PORT 25
ENV MAIL_ENCRYPTION tls
ENV MAIL_HOST localhost
ENV MAIL_FROM_ADDRESS user@domain.com
ENV MAIL_FROM_NAME mailfrom
ENV MAIL_PASSWORD mailpass
ENV MAIL_USERNAME mailuser

ENV GOOGLE_ANALYTICS_ID 123

ENV TWITTER_WIDGET_ID 123

ENV LOG errorlog

# Create directory
RUN mkdir -p /var/www/html
RUN git clone https://github.com/Attendize/Attendize.git /var/www/html
WORKDIR /var/www/html
RUN git checkout tags/v0.5.1-alpha
RUN composer install
RUN php artisan attendize:install
ENV
RUN a2enmod rewrite
