#!/bin/bash

# Catch errors and undefined variables
set -euo pipefail

# Set environment variables
export JAVA_HOME="/usr/lib/jvm/jre"

# This is the path of the config file
readonly BUILDOMATIC_DIR="$(cd ${UPLOADS_DIR}/**/buildomatic; pwd)"
readonly CONF="${BUILDOMATIC_DIR}/default_master.properties"

# Wait for database to start then...
while ! /usr/pgsql-9.6/bin/pg_isready -h "$DATABASE_HOST" -U "$DATABASE_USER" -p "$DATABASE_PORT" -d "$DATABASE_NAME" --quiet; do
    echo "Waiting for database to become available"
    sleep 2
done
echo "Database available, continuing with application configuration and deploy"

# Check if the script has been executed before
readonly SCRIPT_PATH=$(cd "$(dirname $0)" && pwd)
readonly EXECUTED_ONCE_STAMP="${SCRIPT_PATH}/.boot-completed-once"
if [ -f "$EXECUTED_ONCE_STAMP" ]; then
  echo "The script was already executed before"
  exit 0
fi

# Replace config file template variables with the values from the environment
if [ "$DATABASE_TYPE" = "postgres" ]; then
    sed -i -e "s/^dbType=.*/dbType=postgresql/" "$CONF"
else
    sed -i -e "s/^dbType=.*/dbType=${DATABASE_TYPE}/" "$CONF"
fi
sed -i -e "s/^dbHost=.*/dbHost=${DATABASE_HOST}/" "$CONF"
sed -i -e "s/^dbUsername=.*/dbUsername=${DATABASE_USER}/" "$CONF"
sed -i -e "s/^dbPassword=.*/dbPassword=${DATABASE_PASSWORD}/" "$CONF"
sed -i -e "s/^[ #]*js.dbName=.*/js.dbName=${DATABASE_NAME}/" "$CONF"


cd "$BUILDOMATIC_DIR"
# Update webapp datasource with the updated database data
./js-ant set-ce-webapp-name deploy-webapp-datasource-configs
# Execute sql file to populate database
./js-ant init-js-db-ce
# Import minimal resources to webapp
./js-ant import-minimal-ce

# Import fictitious sample data
# ./js-ant create-foodmart-db
# ./js-ant load-foodmart-db
# ./js-ant update-foodmart-db
# ./js-ant import-sample-data-ce

# Once the boot script is finished, create flag file
touch "$EXECUTED_ONCE_STAMP"
