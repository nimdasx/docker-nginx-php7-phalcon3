FROM webdevops/php-nginx:7.3

LABEL maintainer="nimdasx@gmail.com" \
      description="nginx php-7.3 phalcon-3.4.5"

# set timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# copy konfigurasi custom
COPY php-nimdasx.ini /usr/local/etc/php/conf.d/php-nimdasx.ini
COPY vhost.conf /opt/docker/etc/nginx/vhost.conf

# perbarui apt buster pindah ke archive karena sudah tidak di support
RUN curl -fsSL https://nginx.org/keys/nginx_signing.key | gpg --dearmor -o /usr/share/keyrings/nginx-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/debian buster nginx" > /etc/apt/sources.list.d/nginx.list && \
    sed -i 's|deb.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    sed -i 's|security.debian.org|archive.debian.org|g' /etc/apt/sources.list && \
    sed -i '/stretch-updates/d' /etc/apt/sources.list && \
    echo "Acquire::Check-Valid-Until false;" > /etc/apt/apt.conf.d/99no-check-valid-until

# dependensi
RUN apt-get -y update && \
    apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libzip-dev \
    unzip \
    libpng-dev \
    libpq-dev \
    gnupg \
    gnupg2 \
    gnupg1 \
    git

# php ext 
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install zip mysqli pdo_mysql pdo_pgsql gd && \
    rm -rf /var/lib/apt/lists/*

# phalcon
COPY cphalcon-3.4.5.zip /usr/local/src/
RUN cd /usr/local/src && \
    unzip cphalcon-3.4.5.zip && \
    cd cphalcon-3.4.5/build && \
    ./install && \
    cd / && \
    rm -rf /usr/local/src/* && \
    docker-php-ext-enable phalcon


# redis
# redis terbaru (6.2.0) kemungkinan yang bikin crash php 7.3.3
RUN pecl install -o -f redis-5.3.7 && \
    rm -rf /tmp/pear && \
    docker-php-ext-enable redis

# sqlsrv
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get -y update && \
    ACCEPT_EULA=Y apt-get install -y \
      msodbcsql17 \
      mssql-tools \
      unixodbc-dev \
      libgssapi-krb5-2 && \
    rm -rf /var/lib/apt/lists/* && \
    pecl install sqlsrv-5.9.0 pdo_sqlsrv-5.9.0 && \
    docker-php-ext-enable sqlsrv pdo_sqlsrv && \
    sed -i 's/TLSv1.2/TLSv1.0/g' /etc/ssl/openssl.cnf