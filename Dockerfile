FROM ubuntu:latest

# Update system and install programs
RUN apt-get update -qq
RUN apt-get install -qq -y curl apache2 php5 libapache2-mod-php5 php5-mcrypt php5-gd php5-curl mysql-client php5-mysql supervisor wget
RUN apt-get autoclean
RUN apt-get autoremove -qqy --purge
RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor

# Download tiny-tiny-rss, latest link can be found at http://tt-rss.org/redmine/projects/tt-rss/wiki#download
RUN wget https://github.com/gothfox/Tiny-Tiny-RSS/archive/1.13.tar.gz
RUN tar xvzf 1.13.tar.gz
RUN rm 1.13.tar.gz

# Create tiny-tiny-rss installation folder, replace tiny-tiny-rss-x.xx by download version above
RUN mv Tiny-Tiny-RSS-1.13 /var/www/tt-rss

# Change permissions in installation folder
RUN chmod -R 777 /var/www/tt-rss/cache/images
RUN chmod -R 777 /var/www/tt-rss/cache/export
RUN chmod -R 777 /var/www/tt-rss/cache/upload
RUN chmod -R 777 /var/www/tt-rss/cache/js
RUN chmod -R 777 /var/www/tt-rss/feed-icons
RUN chmod -R 777 /var/www/tt-rss/lock

# Copy configuration files
COPY vhost.conf /etc/apache2/sites-available/000-default.conf
COPY config-template.php /var/www/tt-rss/config-template.php
COPY ttrss-config.sh /usr/sbin/ttrss-config.sh
#RUN chmod 777 /usr/sbin/ttrss-config.sh 
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create Ubuntu user ttrss:www-data and grant permissions on installation folder
RUN useradd -G www-data ttrss
RUN chown -R www-data:www-data /var/www/tt-rss

EXPOSE 22 80

CMD ["/usr/bin/supervisord"]
