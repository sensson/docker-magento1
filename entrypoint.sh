#!/bin/bash

set -eo pipefail
COMMAND="$@"

if [ -n "$COMMAND" ]; then
	echo "ENTRYPOINT: Executing override command"
	exec $COMMAND
else
	# Setup Magento configuration
	if [ -n "$URI" ]; then
		echo "Updating URI to $URI.. "
		mysql -h$MYSQL_HOSTNAME -u$MYSQL_USERNAME -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "update ${TABLE_PREFIX}core_config_data set value = '$URI' where path = 'web/unsecure/base_url';"
		mysql -h$MYSQL_HOSTNAME -u$MYSQL_USERNAME -p$MYSQL_PASSWORD $MYSQL_DATABASE -e "update ${TABLE_PREFIX}core_config_data set value = '$URI' where path = 'web/secure/base_url';"
	fi

	# Make sure our settings make sense
	if [ -f /var/www/html/app/etc/local.xml ]; then
		xmlstarlet edit -L -u "/config/global/resources/db/table_prefix" -v $TABLE_PREFIX /var/www/html/app/etc/local.xml
		xmlstarlet edit -L -u "/config/global/crypt/key" -v $CRYPTO_KEY /var/www/html/app/etc/local.xml
		xmlstarlet edit -L -u "/config/global/resources/default_setup/connection/host" -v $MYSQL_HOSTNAME /var/www/html/app/etc/local.xml
		xmlstarlet edit -L -u "/config/global/resources/default_setup/connection/username" -v $MYSQL_USERNAME /var/www/html/app/etc/local.xml
		xmlstarlet edit -L -u "/config/global/resources/default_setup/connection/password" -v $MYSQL_PASSWORD /var/www/html/app/etc/local.xml
		xmlstarlet edit -L -u "/config/global/resources/default_setup/connection/dbname" -v $MYSQL_DATABASE /var/www/html/app/etc/local.xml
	fi

	# Allow exceptions to be printed if we're running a development environment
	if [ "$RUNTYPE" == "development" ]; then
		if [ -f /var/www/html/errors/local.xml.sample ]; then
			mv /var/www/html/errors/local.xml.sample /var/www/html/errors/local.xml
		fi

		echo 'display_errors = On' >> /usr/local/etc/php/conf.d/00_production.ini
	else
		echo 'display_errors = Off' >> /usr/local/etc/php/conf.d/00_production.ini
	fi

	# Reset permissions
	echo "Changing permissions to www-data.. "
	chown -R www-data: /var/www/html

	# Start Apache
	exec /usr/local/bin/apache2-foreground
fi
