#!/bin/bash

# Catch errors and undefined variables
set -euo pipefail

# Load DATABASE_ env variables
export $(stacksmith_get_db_parameters_env | xargs)

# The directory where the app is installed
readonly installdir=/opt/app
# The user that should run the app
readonly system_user=bitnami

# Wait for the database to be available
while ! mongo "mongodb://$DATABASE_USER:$DATABASE_PASSWORD@$DATABASE_HOST:$DATABASE_PORT/$DATABASE_NAME?${DATABASE_CONNECTION_OPTIONS:-}" --eval '{ping: 1}' --quiet;
do
    echo "Waiting for database to become available"
    sleep 2
done
echo "Database available, continuing to run application."

# Typically this is used to start something on foreground
exec su "${system_user}" -c "cd ${installdir} && npm start"
