# PHP 8.0.30 is the final PHP 8.0 release and only ships on Debian 11 (bullseye).
FROM php:8.0.30-fpm-bullseye

# Debian 11 is end-of-life; its packages now live on archive.debian.org.
RUN printf '%s\n' \
        'deb http://archive.debian.org/debian bullseye main' \
        'deb http://archive.debian.org/debian-security bullseye-security main' \
        > /etc/apt/sources.list \
    && rm -f /etc/apt/sources.list.d/*

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libpng-dev \
    libzip-dev \
    unzip \
    git \
    ffmpeg \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Pin the last PECL releases that still support PHP 8.0.
RUN pecl install \
    redis-6.0.2 \
    imagick-3.7.0 \
    xdebug-3.3.2

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
    pcntl \
    opcache

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
