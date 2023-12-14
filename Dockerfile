FROM php:8.3-fpm

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libpng-dev \
    libzip-dev \
    unzip \
    ffmpeg

RUN pecl install \
    redis \
    imagick \
    xdebug

RUN docker-php-ext-enable \
    redis \
    imagick \
    xdebug

RUN docker-php-ext-configure \
    gd --with-freetype --with-jpeg

RUN docker-php-ext-configure \
    calendar

RUN docker-php-ext-configure \
    pcntl --enable-pcntl

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
    calendar \
    pcntl

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ENV PHP_MEMORY_LIMIT=512M

RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'memory_limit = 512M' >> /usr/local/etc/php/conf.d/docker-php-memory-limit.ini

ENV NODE_VERSION=20.10.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN corepack enable

RUN echo "xdebug.mode = debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.client_host = host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
