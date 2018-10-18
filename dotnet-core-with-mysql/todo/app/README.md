This is a fork of the Simple asp net core todo app based on LittleAspNetCoreBook taken from https://github.com/andredarcie/simple-asp-net-core-2-todo-app ; it  is available at https://github.com/wojciechka/simple-asp-net-core-2-todo-app.

The fork adds support for MySQL as the database for storing user information and todo items.

# Packaging the application

To build from command line, simply build and create publish directory using the `Release` configuration - such as:

```
$ dotnet publish -c Release -r linux-x64 --self-contained=false
```

The above command works on Windows with Visual Studio and .NET Core development features installed as well as on any system with .NET Core installed.

This will create a folder called `bin/Release/netcoreapp2.0/linux-x64/publish` that contains the application directory structure along with all the dependencies required to run it by .NET Core runtime.

Then package the contents of the output directory - either using a GUI tool like 7-zip or on a Linux/macOS system, using the `zip` command - for example:

```
$ cd bin/Release/netcoreapp2.0/linux-x64/publish && zip -r -9 ../application.zip .
```

# Configuring and initializing database

In order to configure the database connection, edit the `appsettings.json` file and change the `DefaultConnection` string - specifying it in the form of:

```
Server=(database-host);Database=(database-name);Uid=(database-user);Pwd=(database-password);
```

Next, initialize the database schema (if not already initialized) using the `mysql-schema.sql` - such as:

```
if ! mysql "-u${DATABASE_USER}" "-p${DATABASE_PASSWORD}" "-h${DATABASE_HOST}" "${DATABASE_NAME}" -e "SELECT COUNT(*) FROM Items;" ; then
    mysql "-u${DATABASE_USER}" "-p${DATABASE_PASSWORD}" "-h${DATABASE_HOST}" "${DATABASE_NAME}" -B <mysql-schema.sql
fi
```

This will check whether `Items` table exists in the specified database and if it does not, it will create the database schema using the included `mysql-schema.sql` file.
