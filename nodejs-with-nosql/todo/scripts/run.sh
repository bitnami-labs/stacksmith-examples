#!/bin/bash

# Catch errors and undefined variables
set -euo pipefail

# The directory where the app is installed
readonly installdir=/opt/app
# The user that should run the app
readonly system_user=bitnami

# Typically this is used to start something on foreground
exec su "${system_user}" -c "cd ${installdir} && npm start"
