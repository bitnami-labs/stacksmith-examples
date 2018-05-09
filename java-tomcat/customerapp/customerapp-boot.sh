#!/bin/bash
set -euo pipefail

readonly CONF=WEB-INF/classes/application.yml
readonly FIRSTBOOT_STAMP=/.firstboot-complete

# Wait for database to start then...
while ! mysqladmin ping -h"$DATABASE_HOST" -P"$DATABASE_PORT" -u"$DATABASE_USER" -p"$DATABASE_PASSWORD" --silent; do
    echo "Waiting for database to become available"
    sleep 2
done
echo "Database available, continuing with application configuration and deploy"

# Only perform the setup once
if [ ! -f "${FIRSTBOOT_STAMP}" ] ; then
    # Jump to the webapp directory
    basedir=$(find /var/lib/tomcat/webapps/ -mindepth 1 -maxdepth 1 -not -name 'ROOT' -type d | head -n 1)
    cd "${basedir}"

    # Configure database settings
    touch "$CONF" && chmod 600 "$CONF" && chown tomcat:tomcat "$CONF"
    echo "spring.datasource.url: jdbc:mysql://$DATABASE_HOST:$DATABASE_PORT/$DATABASE_NAME?useSSL=true" >> "$CONF"
    echo "spring.datasource.username: $DATABASE_USER" >> "$CONF"
    echo "spring.datasource.password: $DATABASE_PASSWORD" >> "$CONF"

    touch "${FIRSTBOOT_STAMP}"
fi
