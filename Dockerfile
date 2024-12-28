FROM alpine:latest

# Add the edge community repository for additional PHP packages
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# Install system dependencies and PHP 8.2
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
    gcc \
    g++ \
    make \
    autoconf \
    build-base \
    git \
    openssl-dev

# Download and compile MongoDB PHP extension
RUN mkdir -p /usr/src/php/ext/mongodb \
    && curl -L https://github.com/mongodb/mongo-php-driver/archive/refs/tags/1.14.2.tar.gz | tar -xz -C /usr/src/php/ext/mongodb --strip-components=1 \
    && cd /usr/src/php/ext/mongodb \
    && phpize82 \
    && ./configure --with-php-config=/usr/bin/php-config82 \
    && make \
    && make install \
    && echo "extension=mongodb.so" > /etc/php82/conf.d/00_mongodb.ini \
    && rm -rf /var/cache/apk/* /usr/src/php/ext/mongodb

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
