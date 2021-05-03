FROM php:7.3-apache
RUN apt-get update && apt-get -y install libpng-dev
RUN docker-php-ext-install mysqli gd exif
ADD piwigo/ /var/www/html/
RUN chmod 777  -R /var/www/html/
WORKDIR /var/www/html/
EXPOSE 80