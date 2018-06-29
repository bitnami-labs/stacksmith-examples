#!/bin/bash

readonly appdir="/opt/app"

set -euo pipefail

sed -i \
    "s!\(DefaultConnection.*\)\"Server=.*\"!\\1\"Server=${DATABASE_HOST}\\;Database=${DATABASE_NAME}\\;Uid=${DATABASE_USER};Pwd=${DATABASE_PASSWORD}\\;\"!" \
    "${appdir}/appsettings.json"

mysql --ssl "-u${DATABASE_USER}" "-p${DATABASE_PASSWORD}" "-h${DATABASE_HOST}" "${DATABASE_NAME}" -e "SELECT 1+1;"
if ! mysql --ssl "-u${DATABASE_USER}" "-p${DATABASE_PASSWORD}" "-h${DATABASE_HOST}" "${DATABASE_NAME}" -e "SELECT COUNT(*) FROM Items;" ; then
    mysql --ssl "-u${DATABASE_USER}" "-p${DATABASE_PASSWORD}" "-h${DATABASE_HOST}" "${DATABASE_NAME}" -B <"${appdir}/mysql-schema.sql"
fi

