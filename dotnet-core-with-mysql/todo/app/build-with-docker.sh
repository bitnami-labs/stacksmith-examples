#!/bin/bash

set -eu -o pipefail

if [ ! -d ./wwwroot ] ; then
  echo "Please run the script in the application source code root directory"
  exit 2
fi

docker run --rm -v $(pwd):/src -v /src/bin -v /src/obj microsoft/dotnet:2.1-sdk bash -c \
  'apt-get update && apt-get -y install zip && cd /src && dotnet publish -c Release && cd bin/Release/netcoreapp2.0/publish && zip -r -9 /src/simple-asp-net-core-2-todo-app.zip .'

