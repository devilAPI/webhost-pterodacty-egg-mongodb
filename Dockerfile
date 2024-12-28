FROM alpine:latest

# Add the edge community repository for additional PHP packages
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# Install system dependencies and PHP 8.2 along with necessary build tools
RUN apk --update --no-cache add \
    curl \
    ca-certificates \
    nginx \
    php82 \
    php82-xml \
    php82-exif \
    php82-fpm \
    php82-session \
    php82-soap \
    php82-openssl \
    php82-gmp \
    php82-pdo_odbc \
    php82-json \
    php82-dom \
    php82-pdo \
    php82-zip \
    php82-mysqli \
    php82-sqlite3 \
    php82-pdo_pgsql \
    php82-bcmath \
    php82-gd \
    php82-odbc \
    php82-pdo_mysql \
    php82-pdo_sqlite \
    php82-gettext \
    php82-xmlreader \
    php82-bz2 \
    php82-iconv \
    php82-pdo_dblib \
    php82-curl \
    php82-ctype \
    php82-phar \
    php82-fileinfo \
    php82-mbstring \
    php82-tokenizer \
    php82-simplexml \
    php82-dev \
    php82-pear \
    gcc \
    g++ \
    make \
    autoconf \
    build-base \
    openssl-dev

# Ensure pecl is available
RUN ln -s /usr/bin/pecl82 /usr/bin/pecl \
    && pecl version

# Install MongoDB PHP extension using pecl
RUN pecl install mongodb \
    && mkdir -p /home/container/php-fpm/conf.d \
    && echo "extension=mongodb.so" > /home/container/php-fpm/conf.d/00_mongodb.ini \
    && rm -rf /var/cache/apk/*

# Copy Composer from its official image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set up container user and environment
USER container
ENV USER container
ENV HOME /home/container

# Set working directory and copy entrypoint script
WORKDIR /home/container
COPY ./entrypoint.sh /entrypoint.sh

# Set the default command
CMD ["/bin/ash", "/entrypoint.sh"]
