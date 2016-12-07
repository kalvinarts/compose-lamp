FROM debian:latest

MAINTAINER Albert Calbet <kalvin@unseen.is>

# Update packages list
RUN DEBIAN_FRONTEND=noninteractive apt-get update

# Install software for installation automation and repo management
RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get install apt-utils -y; \
    apt-get install -y software-properties-common wget

# Install the dotdeb repo
RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-add-repository -s 'deb http://packages.dotdeb.org jessie all'; \
    wget -O /tmp/dotdeb.gpg https://www.dotdeb.org/dotdeb.gpg; \
    apt-key add /tmp/dotdeb.gpg; \
    rm /tmp/dotdeb.gpg

# Update the packages list and install the latest versions available
RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update -y; \
    apt-get upgrade -y

# Install apache, php5 and php7
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2 apache2-suexec libapache2-mod-fcgid \
    php5 php5-cgi php5-fpm php-xml php5-mysql php-mbstring php5-curl php5-gd \
    php7.0 php7.0-cgi php7.0-fpm php7.0-xml php7.0-mysql php7.0-mbstring php7.0-curl php7.0-gd

# Install other packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim

# Enable
RUN a2enmod proxy_fcgi setenvif
RUN a2enconf php7.0-fpm
RUN a2enmod rewrite

# Enable short tags
# for php5
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/fpm/php.ini
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/cgi/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/fpm/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/cgi/php.ini
# for php7
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/cgi/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.0/fpm/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.0/cgi/php.ini

# Setup php5-fpm
RUN sed -i \
    -e 's|^\[www\]|[www.php5]|' \
    -e 's|^listen =.*|listen = 127.0.0.1:9005|' \
    -e 's|^;*request_terminate_timeout.*|request_terminate_timeout = 605|' \
    -e 's|^;*pm.status_path.*|pm.status_path = /php5-fpm-status|' \
    -e 's|^;*ping.path.*|ping.path = /php5-fpm-ping|' \
    '/etc/php5/fpm/pool.d/www.conf'

# Setup php7.0-fpm
RUN sed -i \
    -e 's|^\[www\]|[www.php7]|' \
    -e 's|^listen =.*|listen = 127.0.0.1:9007|' \
    -e 's|^;*request_terminate_timeout.*|request_terminate_timeout = 605|' \
    -e 's|^;*pm.status_path.*|pm.status_path = /php7.0-fpm-status|' \
    -e 's|^;*ping.path.*|ping.path = /php7.0-fpm-ping|' \
    '/etc/php/7.0/fpm/pool.d/www.conf'

# setup apache environment vars
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

# Expose apache.
EXPOSE 80

# Copy this repo into place.
VOLUME /var/www

# Update the default apache site with the config we created.
ADD sites-enabled/00-default.conf /etc/apache2/sites-enabled/000-default.conf

# Inject entrypoint.sh
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# By default start up apache in the foreground, override with /bin/bash for interative.
CMD /entrypoint.sh
