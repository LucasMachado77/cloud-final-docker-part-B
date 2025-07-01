FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    libpq-dev \
    unzip \
    && docker-php-ext-install pdo pdo_pgsql \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

# Copia só o conteúdo da pasta html
COPY app/html/ ./
COPY app/composer.json app/composer.lock ./

RUN composer install --no-dev --optimize-autoloader

RUN chown -R www-data:www-data /var/www/html