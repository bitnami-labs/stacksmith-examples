# .NET Core Application with DB (MySQL): Simple asp net core to-do application (deprecated)

## Deprecation notice

This example has been deprecated, newer versions can be found at [bitnami-labs/stacksmith-dotnet-with-mysql](https://github.com/bitnami-labs/stacksmith-dotnet-with-mysql).

## Description

This is an example to show how to deploy an application using the `.NET Core Application with DB (MySQL)` stack template in [Bitnami Stacksmith](stacksmith.bitnami.com).

## Package and deploy with Stacksmith

1. Go to [stacksmith.bitnami.com](https://stacksmith.bitnami.com)
2. Create a new application and select the _.NET Core Application with DB (MySQL)_ stack template.
3. Select the targets you are interested on (AWS, Kubernetes,...)
4. Upload the [_simple-asp-net-core-2-todo-app.zip_](../../../../releases/download/v1/simple-asp-net-core-2-todo-app.zip) file (which can be found in [releases](../../../../releases) for the project.
5. Upload the [_boot.sh_](scripts/boot.sh) script from the [_scripts/_](scripts/) folder.
6. Click the <kbd>Create</kbd> button.
7. Launch it in [AWS](https://stacksmith.bitnami.com/support/quickstart-aws) or download the helm chart to run it in [Kubernetes](https://stacksmith.bitnami.com/support/quickstart-k8s)
8. Access your application: http://IP for AWS or http://IP:8080 for Kubernetes and Azure

## Scripts

There application requires a boot script that performs application specific initialization.

### boot.sh

This script takes care of initializing the database and configuring the application: Basically, it does:

* modify `appsettings.json` file to specify the connection to database
* initialize and populate the database

## Packaging the application from source code

The _simple-asp-net-core-2-todo-app.zip_ file can also be created by building the application in the [_app/_](app/) folder. To build it, you need to have .NET Core SDK installed.

Simply run the following command in the [_app/_](app/) folder:

```
dotnet publish -c Release
```

The command sets up all required dependencies, builds the application and creates a `publish` folder with the application and dependencies packages.

Next, package the application - such as by doing the following:

```
$ cd app/bin/Release/netcoreapp2.0/publish && zip -r -9 ../simple-asp-net-core-2-todo-app.zip .
```

