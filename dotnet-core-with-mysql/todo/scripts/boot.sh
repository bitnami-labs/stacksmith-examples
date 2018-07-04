#!/bin/bash

readonly appdir="/opt/app"

set -euo pipefail

sed -i \
    "s!\(DefaultConnection.*\)\"Server=.*\"!\\1\"Server=${DATABASE_HOST}\\;Database=${DATABASE_NAME}\\;Uid=${DATABASE_USER};Pwd=${DATABASE_PASSWORD}\\;\"!" \
    "${appdir}/appsettings.json"

# Wait for database to start then...
while ! mysqladmin ping -h"$DATABASE_HOST" -P"$DATABASE_PORT" -u"$DATABASE_USER" -p"$DATABASE_PASSWORD" --silent; do
    echo "Waiting for database to become available"
    sleep 2
done
echo "Database available, continuing with application configuration and deploy"

mysql --ssl "-u${DATABASE_USER}" "-p${DATABASE_PASSWORD}" "-h${DATABASE_HOST}" "${DATABASE_NAME}" -e "SELECT 1+1;"
if ! mysql --ssl "-u${DATABASE_USER}" "-p${DATABASE_PASSWORD}" "-h${DATABASE_HOST}" "${DATABASE_NAME}" -e "SELECT COUNT(*) FROM Items;" ; then
    mysql --ssl "-u${DATABASE_USER}" "-p${DATABASE_PASSWORD}" "-h${DATABASE_HOST}" "${DATABASE_NAME}" -B <"${appdir}/mysql-schema.sql"
fi

