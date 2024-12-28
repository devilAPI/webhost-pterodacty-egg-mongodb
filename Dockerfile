FROM alpine:latest

# Install necessary packages, including PHP and MongoDB extension
RUN apk --update --no-cache add curl ca-certificates nginx \
    && apk add php8 php8-xml php8-exif php8-fpm php8-session php8-soap php8-openssl php8-gmp php8-pdo_odbc php8-json php8-dom php8-pdo php8-zip php8-mysqli php8-sqlite3 php8-pdo_pgsql php8-bcmath php8-gd php8-odbc php8-pdo_mysql php8-pdo_sqlite php8-gettext php8-xmlreader php8-bz2 php8-iconv php8-pdo_dblib php8-curl php8-ctype php8-phar php8-fileinfo php8-mbstring php8-tokenizer php8-simplexml \
    && apk add php8-pecl-mongodb \
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
