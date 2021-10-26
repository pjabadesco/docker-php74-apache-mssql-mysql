FROM php:7.4-apache

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libedit-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    freetds-dev \
    freetds-bin \
    freetds-common \
    libdbd-freetds \
    libsybdb5 \
    libqt5sql5-tds \
    libmcrypt-dev \
    libpng-dev \
    unixodbc \
    unixodbc-dev \
    libzip-dev \
    zip unzip \
    php7.4-common/stable php7.4-mbstring/stable php7.4-xml/stable php7.4-xmlrpc/stable \
    && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/libsybdb.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a \
    && apt-get clean \
    && rm -r /var/lib/apt/lists/* 

RUN pecl install redis \
    && docker-php-ext-enable redis

RUN docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr \ 
    && docker-php-ext-install soap xmlrpc intl zip gd pdo pdo_odbc pdo_mysql curl json mysqli pdo_dblib opcache \
    && pecl install sqlsrv pdo_sqlsrv xdebug \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv xdebug

COPY conf/php.ini /usr/local/etc/php/
COPY conf/httpd.conf /etc/apache2/sites-available/000-default.conf
COPY www/ /var/www/html/

RUN a2enmod rewrite headers \
    && chmod 755 /var/www/html -R \
    && chown www-data:www-data /var/www/html 