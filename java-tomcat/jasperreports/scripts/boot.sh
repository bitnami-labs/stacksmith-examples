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
echo "Database available, testing SSL availability..."

# Test for SSL connection as postgres' sslmode connection param no longer supports
# the 'prefer' option or a way to trySSL before reverting:
# https://github.com/pgjdbc/pgjdbc/blob/REL42.2.2/pgjdbc/src/main/java/org/postgresql/core/v3/ConnectionFactoryImpl.java#L105
# so test manually and set the SSL_MODE explicitly.
export PGSSLROOTCERT=/etc/pki/tls/certs/ca-bundle.crt
if PGPASSWORD=$DATABASE_PASSWORD psql -wlo /dev/null "sslmode=verify-ca host=$DATABASE_HOST dbname=$DATABASE_NAME user=$DATABASE_USER"; then
    readonly SSL_MODE="verify-ca&sslrootcert=$PGSSLROOTCERT"
else
    readonly SSL_MODE="disable"
fi

echo "SSLMode: $SSL_MODE. Continuing with application configuration and deploy"

# Check if the script has been executed before
readonly SCRIPT_PATH=$(cd "$(dirname $0)" && pwd)
readonly EXECUTED_ONCE_STAMP="${SCRIPT_PATH}/.boot-completed-once"
if [ -f "$EXECUTED_ONCE_STAMP" ]; then
  echo "The script was already executed before"
  exit 0
fi

# Replace config file template variables with the values from the environment
sed -i -e "s/^dbType=.*/dbType=postgresql/" "$CONF"
# Supporting SSL requires using the js.jdbcUrl rather than the buildomatic
# support for the dbHost etc.
# see buildomatic/conf_source/db/postgresql/db.template.properties
echo "js.jdbcDriverClass=org.postgresql.Driver" >> "$CONF"
echo "js.jdbcUrl=jdbc:postgresql://$DATABASE_HOST/$DATABASE_NAME?sslmode=$SSL_MODE" >> "$CONF"
sed -i -e "s/^dbHost=.*/# dbHost=${DATABASE_HOST}/" "$CONF"
sed -i -e "s/^dbUsername=.*/dbUsername=${DATABASE_USER}/" "$CONF"
sed -i -e "s/^dbPassword=.*/dbPassword=${DATABASE_PASSWORD}/" "$CONF"
sed -i -e "s/^[ #]*js.dbName=.*/js.dbName=${DATABASE_NAME}/" "$CONF"


cd "$BUILDOMATIC_DIR"
# Update webapp datasource with the updated database data
./js-ant set-ce-webapp-name deploy-webapp-datasource-configs
# The above deploy-webapp-datasource-configs ant command inserts the jdbc url but
# does *not* encode the ampersand for the xml file, leaving tomcat unable to parse.
# At the same time, the js-ant steps require the plain URL without encoding.
sed -i -e "s/sslmode=verify-ca&sslrootcert/sslmode=verify-ca\&amp;sslrootcert/" \
    /var/lib/tomcat/webapps/jasperserver/META-INF/context.xml

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
