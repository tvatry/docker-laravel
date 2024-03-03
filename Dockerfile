FROM php:7.3-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid

# Install system dependencies
RUN apt-get update && apt-get install -y \
    --allow-unauthenticated \
    git \
    curl \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    gnupg2 \
    locales \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libwebp-dev

# UTF8
RUN sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    export LC_ALL=fr_FR.UTF-8 && \
    export LANG=fr_FR.UTF-8 && \
    export LANGUAGE=fr_FR:en

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip soap

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u 1000 -d /home/sammy sammy && \
    mkdir -p /home/sammy/.composer && \
    chown -R sammy:sammy /home/sammy

# Set working directory
WORKDIR /var/www

USER $user
