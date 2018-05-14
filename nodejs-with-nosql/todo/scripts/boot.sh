#!/bin/bash

# Catch errors and undefined variables
set -euo pipefail

# This is the path of the database config file inside your app
readonly database_conf_file=/opt/app/config/database.js
# The directory where the app is installed
readonly installdir=/opt/app
# The user that should run the app
readonly system_user=bitnami

# Replace config file variables with the values from the environment
sed -i -e "s/process.env.DATABASE_HOST/\"${DATABASE_HOST}\"/" "${database_conf_file}"
sed -i -e "s/process.env.DATABASE_PORT/\"${DATABASE_PORT}\"/" "${database_conf_file}"
sed -i -e "s/process.env.DATABASE_USER/\"${DATABASE_USER}\"/" "${database_conf_file}"
sed -i -e "s/process.env.DATABASE_NAME/\"${DATABASE_NAME}\"/" "${database_conf_file}"
sed -i -e "s/process.env.DATABASE_PASSWORD/\"${DATABASE_PASSWORD}\"/" "${database_conf_file}"
# On Azure the DATABASE_CONNECTION_OPTIONS specify ssl=true (as tls is
# required), whereas on AWS we don't use tls for the mongo connection (yet).
sed -i -e "s/process.env.DATABASE_CONNECTION_OPTIONS/\"${DATABASE_CONNECTION_OPTIONS:-}\"/" "${database_conf_file}"
