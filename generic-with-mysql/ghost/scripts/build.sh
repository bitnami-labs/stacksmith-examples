#!/bin/bash

# Catch errors and undefined variables
set -euo pipefail

source "${UPLOADS_DIR}/env"

# Install deps
yum install -y wget sudo unzip epel-release nginx nodejs npm
wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo
yum install -y yarn

# Get Ghost
wget https://github.com/TryGhost/Ghost/releases/download/1.25.5/Ghost-1.25.5.zip -O /tmp/ghost.zip
mkdir -p "$(dirname $APP_DIR)"
unzip /tmp/ghost.zip -d "$APP_DIR"
rm /tmp/ghost.zip

# Create non-root user with sudo privileges
adduser "$NON_ROOT_USER" --home-dir "$NON_ROOT_HOME"
echo "$NON_ROOT_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install Ghost
cd "$APP_DIR"
yarn install

# Set ownership
chown -R "$NON_ROOT_USER":"$NON_ROOT_USER" "$APP_DIR"

