#!/bin/bash
# create mysql user and mysql database, from environment vars if any

# Create ENV vars shortcuts
MYSQL_IP=${MYSQL_PORT_3306_TCP_ADDR}
MYSQL_PORT=${MYSQL_PORT_3306_TCP_PORT}
MYSQL_PASSWORD=${MYSQL_ENV_MYSQL_ROOT_PASSWORD}
HOST_IP="$(hostname -i)"
DB_NAME=${TTRSS_DB_NAME:=ttrss}	# Default database name to 'ttrss'
DB_USER=${TTRSS_DB_USER:=root}	# Default database user to 'root'
DB_PASSWORD=${TTRSS_DB_PASSWORD:=${MYSQL_ENV_MYSQL_ROOT_PASSWORD}} # Default user password to linked mysql container root password

# Create new database if necessary,
# grant privileges to new user,
# and fill it with ttrss schema
if ! mysql -u root -h ${MYSQL_IP} -p${MYSQL_PASSWORD} -e 'SHOW DATABASES\G'|grep ${DB_NAME}; then
	date
	echo "${DB_NAME} not present. creating..."
	/usr/bin/mysql -u root -h ${MYSQL_IP} -p${MYSQL_PASSWORD} -e "
		CREATE DATABASE IF NOT EXISTS ${DB_NAME};
		GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'${HOST_IP}' IDENTIFIED BY '${DB_PASSWORD}';
		USE ${DB_NAME};
		SOURCE /var/www/tt-rss/schema/ttrss_schema_mysql.sql;"
else
	date
	echo "${DB_NAME} already present"
	/usr/bin/mysql -u root -h ${MYSQL_IP} -p${MYSQL_PASSWORD} -e "
		GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'${HOST_IP}' IDENTIFIED BY '${DB_PASSWORD}';"
fi

# replace database credentials in tt-rss config template
mv /var/www/tt-rss/config.php config.php.backup
sed 's/%DB_NAME%/'${DB_NAME}'/;
	s/%DB_USER%/'${DB_USER}'/;
	s/%DB_PASSWORD%/'${DB_PASSWORD}'/;
	s/%MYSQL_PORT%/'${MYSQL_PORT}'/;
	s/%MYSQL_IP%/'${MYSQL_IP}'/;
	s/%HOST_IP%/'${HOST_IP}'/' /var/www/tt-rss/config-template.php > /var/www/tt-rss/config.php

exit 0

