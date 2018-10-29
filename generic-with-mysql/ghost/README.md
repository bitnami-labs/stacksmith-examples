# Generic application with DB (MySQL): Ghost (deprecated)

## Deprecation notice

This example has been deprecated, newer versions can be found at [bitnami-labs/stacksmith-ghost](https://github.com/bitnami-labs/stacksmith-ghost).

## Description

This is an example to show how to deploy an application using the `Generic application with DB (MySQL)` stack template in [Bitnami Stacksmith](stacksmith.bitnami.com).

We chose [Ghost](https://ghost.org/):

> Ghost is a fully open source, hackable platform for building and running a modern online publication. We power blogs, magazines and journalists from Zappos to Sky News.

## Package and deploy with Stacksmith

1. Go to [stacksmith.bitnami.com](https://stacksmith.bitnami.com)
2. Create a new application and select the _Generic application with DB (MySQL)_ stack template.
3. Select the targets you are interested on (AWS,Kubernetes,...)
4. We created a [_env_](files/env) to keep common configuration along our scripts. Upload it from the [_files_](files/) folder as an application file.
5. Upload the [_build.sh_](scripts/build.sh), [_boot.sh_](scripts/boot.sh) and [_run.sh_](scripts/run.sh) scripts from the [_scripts/_](scripts/) folder.
6. Click the <kbd>Create</kbd> button.
7. Launch it in [AWS](https://stacksmith.bitnami.com/support/quickstart-aws) or download the helm chart to run it in [Kubernetes](https://stacksmith.bitnami.com/support/quickstart-k8s)
8. Access your application: http://IP:8080

## Scripts

There are some scripts to build and initialize this application:

### build.sh

This script takes care of extracting the application and installing dependencies. It performs the next steps:

* Install required extra system packages
* Uncompress the uploaded bundle
* Install Ghost dependencies
* Create a non-root user to run the application

### boot.sh

This script takes care of initializing the database and configuring the application: Basically, it does:

* Create a configuration file with server and database connections
* Initialize and populate the database

### run.sh

This script takes care of starting the application by running `node index.js`.
