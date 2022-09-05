FROM php:8.1-fpm

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libpng-dev \
    libzip-dev \
    unzip

RUN pecl install \
    redis \
    imagick

RUN docker-php-ext-enable \
    redis \
    imagick

RUN docker-php-ext-configure \
    gd --with-freetype --with-jpeg

RUN docker-php-ext-configure \
    calendar

RUN docker-php-ext-install \
    exif \
    -j$(nproc) \
    bcmath \
    gd \
    intl \
    pdo \
    pdo_mysql \
    soap \
    zip \
    calendar

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ENV PHP_MEMORY_LIMIT=512M

RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'memory_limit = 512M' >> /usr/local/etc/php/conf.d/docker-php-memory-limit.ini

ENV NODE_VERSION=16.15.1
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN npm install -g yarn
