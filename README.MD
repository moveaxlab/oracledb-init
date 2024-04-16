# ORACLEDB-INIT

ORACLEDB-INIT is designed to initialize a schema within an Oracle database if it does not already exist. It utilizes SQL*Plus to execute SQL commands within the Oracle database environment.

The script executed within the Docker container performs the following actions:

1. Checks if the specified user exists in the database.
2. If the user does not exist, it creates the user with the provided username and password.
3. Grants necessary privileges to the created user.

## Usage

`docker run -e ADMIN_USER=<admin_user> -e ADMIN_PASSWORD=<admin_password> -e DB_USER=<db_user> -e PASSWORD=<db_password> -e dsn=<connection_string> oracledb-init`

## Environment Variables

- `ADMIN_USER`: The admin username of the Oracle database.
- `ADMIN_PASSWORD`: The admin password of the Oracle database.
- `DB_USER`: The username of the schema to be initialized.
- `PASSWORD`: The password for the new schema.
- `DSN`: The Oracle Data Source Name (DSN) for connection.
