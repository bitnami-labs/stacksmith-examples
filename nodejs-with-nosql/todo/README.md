# MEAN ToDo Application

This is a simple ToDo application to show how to deploy a MEAN application using [Bitnami Stacksmith](https://stacksmith.bitnami.com)

## Package and deploy with Stacksmith

1. Go to [stacksmith.bitnami.com](https://stacksmith.bitnami.com).
2. Create a new application and select the `Node.js with NoSQL DB (MongoDB)` stack template.
3. Select the targets you are interested on (AWS, Kubernetes,...).
4. Compress the _app/_ folder from this repo and upload it as application files:

   ```bash
   git clone https://github.com/bitnami-labs/stacksmith-examples
   cd stacksmith-examples/nodejs-with-nosql/todo
   tar czf app.blue.tar.gz app
   ```
   
You can also download [`app.blue.tar.gz` from the releases page](https://github.com/bitnami-labs/stacksmith-examples/releases/download/v1/app.blue.tar.gz).

5. Upload the [_build.sh_](scripts/build.sh), [_boot.sh_](scripts/boot.sh) and [_run.sh_](scripts/run.sh) scripts from the [_scripts/_](scripts/) folder.
6. Click the <kbd>Create</kbd> button.
7. Wait for app to be built and deploy it in your favorite target platform.

### Update the application with Stacksmith

1. Change something on the app. As an example you can apply the patch `change_color.patch` that changes the color of the task counter:

   ```bash
   cd stacksmith-examples/nodejs-with-nosql/todo
   git apply ./change_color.patch
   tar czf app.orange.tar.gz app
   ```
   
You can also download [`app.orange.tar.gz` from the releases page](https://github.com/bitnami-labs/stacksmith-examples/releases/download/v1/app.orange.tar.gz).
   
2. Go to your app [stacksmith.bitnami.com](https://stacksmith.bitnami.com)
3. Click on <kbd>Edit configuration</kbd>, delete `app.blue.tar.gz` and upload `app.orange.tar.gz`
4. Click <kbd>Update</kbd>.
5. Wait for the new version to be built and re-deploy it in your favorite target platform.

## Use the Stacksmith CLI for automating the process

1. Go to [stacksmith.bitnami.com](https://stacksmith.bitnami.com), create a new application and select the `Node.js with NoSQL DB (MongoDB)` stack template.
2. Install [Stacksmith CLI](https://github.com/bitnami/stacksmith-cli) and authenticate with Stacksmith.
3. Compress the _app/_ folder from this repo:

   ```bash
   git clone https://github.com/bitnami-labs/stacksmith-examples
   cd stacksmith-examples/nodejs-with-nosql/todo
   tar czf app.blue.tar.gz app
   ```
4. Edit the `Stackerfile.yml` and update the `appId` with the URL of your project.
5. Run the build for a specific target like `aws` or `docker`. E.g.

   ```bash
   stacksmith build --target docker
   ```
6. Wait for app to be built and deploy it in your favorite target platform.

### Update the application via CLI

1. Change the app and build a new tarball. You can use the previous example:

   ```bash
   cd stacksmith-examples/nodejs-with-nosql/todo
   git apply ./change_color.patch
   tar czf app.orange.tar.gz app
   ```

2. Update the version and the tarball name in the `Stackerfile.yml`.
3. Run the build for a specific target like `aws` or `docker`. E.g.

   ```bash
   stacksmith build --target docker
   ```

4. Wait for the new version to be built and re-deploy it in your favorite target platform.

## Scripts

In the scripts folder, you can find the required scripts to build and run this application:

### build.sh

This script takes care of installing the application and its dependencies. It performs the next steps:

* Adds the system user that will run the application.
* Uncompress the application code to the `/opt/app` folder.
* Adjust the application files permissions.
* Install dependencies.

### boot.sh

This script takes care of configuring the application.

### run.sh

This script just starts the application with the proper user.
