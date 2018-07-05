#!/bin/bash
# This user build script is required only when using the example with
# Stacksmith's Java Tomcat application with DB (self-managed). The Java Tomcat
# application with DB (MySQL) template already installs the mysql client.
yum install -y mariadb
