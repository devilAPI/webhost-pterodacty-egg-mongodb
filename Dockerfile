FROM alpine:latest

# Add the edge community repository for additional PHP packages
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# Install system dependencies
RUN apk --update --no-cache add \
    curl \
    ca-certificates \
    nginx \
    php \
    php-xml \
    php-exif \
    php-fpm \
    php-session \
    php-soap \
    php-openssl \
    php-gmp \
    php-pdo_odbc \
    php-json \
    php-dom \
    php-pdo \
    php-zip \
    php-mysqli \
    php-sqlite3 \
    php-pdo_pgsql \
    php-bcmath \
    php-gd \
    php-odbc \
    php-pdo_mysql \
    php-pdo_sqlite \
    php-gettext \
    php-xmlreader \
    php-bz2 \
    php-iconv \
    php-pdo_dblib \
    php-curl \
    php-ctype \
    php-phar \
    php-fileinfo \
    php-mbstring \
    php-tokenizer \
    php-simplexml \
    gcc \
    g++ \
    make \
    autoconf

# Install MongoDB PHP extension
RUN pecl install mongodb \
    && echo "extension=mongodb.so" > /home/container/php-fpm/conf.d/mongodb.ini \
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
