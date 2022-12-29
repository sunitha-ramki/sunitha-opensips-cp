FROM debian:bullseye
LABEL maintainer="Sunitha"

USER root

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

ARG OPENSIPS_VERSION=3.3
ARG OPENSIPS_BUILD=releases

#install basic components
RUN apt -y update -qq && apt -y install apt-utils gnupg2 ca-certificates \
                                        curl vim git rsyslog procps wget \
                                        unzip default-mysql-client lsof \
                                        iputils-ping\
                                        apache2 apache2-utils libapache2-mod-php php-curl\
                                        php php-mysql php-gd php-pear php-cli php-apcu


RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf 
RUN /etc/init.d/rsyslog restart

RUN service apache2 restart
#RUN mkdir -p /var/www/html/opensips-cp
COPY 000-default.conf /etc/apache2/sites-avaialble/.

RUN wget https://github.com/OpenSIPS/opensips-cp/archive/8.3.2.zip -O /var/www/html/opensips-cp.zip
RUN unzip /var/www/html/opensips-cp.zip -d /var/www/html
RUN mv /var/www/html/opensips-cp-8.3.2/ /var/www/html/opensips-cp/
RUN chown -R www-data:www-data /var/www/html/opensips-cp/
RUN mysql -h 192.168.0.103 -P 3306 -Dopensips -uopensips -popensipsrw < /var/www/html/opensips-cp/config/db_schema.mysql


COPY db.inc.php /var/www/html/opensips-cp/config/.


EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]



