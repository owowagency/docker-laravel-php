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

# Imagick for php8.3 is broken right now, see https://github.com/Imagick/imagick/pull/641

RUN pecl install \
    redis \
    # imagick \
    xdebug

RUN docker-php-ext-enable \
    redis \
    # imagick \
    xdebug

# So for now we need to build imagick from source

RUN apt-get install -y git

RUN git clone https://github.com/Imagick/imagick.git --depth 1 /tmp/imagick && \
    cd /tmp/imagick && \
    phpize && \
    ./configure && \
    make && \
    make install

RUN docker-php-ext-enable imagick

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
