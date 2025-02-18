FROM php:7.4-apache-buster

RUN a2enmod rewrite headers remoteip

# Install the PHP Driver for SQL Server
RUN apt-get update -yqq 
RUN apt-get install -y libgd3 libgd-dev
RUN apt-get install -y apt-transport-https gnupg wget \
    libcurl4-openssl-dev libedit-dev libsqlite3-dev libssl-dev libxml2-dev zlib1g-dev libmcrypt-dev libpng-dev \
    freetds-dev freetds-bin freetds-common libdbd-freetds libsybdb5 libqt5sql5-tds libzip-dev zip unzip \
    && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/libsybdb.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a \
    && curl -s https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl -s https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update -yqq \
    && ACCEPT_EULA=Y apt-get install -y unixodbc unixodbc-dev libgss3 odbcinst msodbcsql17 locales \
    && echo "en_US.UTF-8 zh_CN.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen

# RUN wget http://www.ijg.org/files/jpegsrc.v9.tar.gz && \
#     tar xvfz jpegsrc.v9.tar.gz && \
#     cd jpeg-9 && \
#     ./configure && \
#     make && \
#     make install

RUN sed -i 's/MinProtocol = TLSv1.2/MinProtocol = TLSv1/g' /etc/ssl/openssl.cnf \
    && sed -i 's/DEFAULT@SECLEVEL=2/DEFAULT@SECLEVEL=1/g' /etc/ssl/openssl.cnf

# Install pdo_sqlsrv and sqlsrv
RUN pecl install -f pdo_sqlsrv sqlsrv  \
    && docker-php-ext-enable pdo_sqlsrv sqlsrv 

RUN pecl install redis \
    && docker-php-ext-enable redis

RUN pecl install mongodb \
    && docker-php-ext-enable mongodb

RUN apt-get install -y libjpeg-dev
RUN docker-php-ext-configure gd --enable-gd --with-jpeg
RUN docker-php-ext-configure pdo_odbc --with-pdo-odbc=unixODBC,/usr \ 
    && docker-php-ext-install gd pdo pdo_mysql pdo_odbc pdo_dblib curl json mysqli opcache

RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip intl xmlrpc soap

RUN apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libbz2-dev
RUN docker-php-ext-configure gd --enable-gd --with-jpeg --with-freetype --with-jpeg 
RUN docker-php-ext-install gd 

# POSTGRES
RUN apt-get install -y libpq-dev
RUN docker-php-ext-install pdo_pgsql pgsql
RUN docker-php-ext-enable pdo_pgsql pgsql

COPY conf/php.ini /usr/local/etc/php/
COPY conf/httpd.conf /etc/apache2/sites-available/000-default.conf
COPY www/ /var/www/html/

# Fix Permission
RUN chmod 755 /var/www/html -R \
    && chown www-data:www-data /var/www/html 
