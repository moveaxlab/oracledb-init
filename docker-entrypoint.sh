#!/bin/bash

if [[ -z "${USE_ADMIN_PWD_FOR_SCHEMAS}" ]]; then
  USE_ADMIN_PWD_FOR_SCHEMAS=false
fi

if [[ -z "${ALLOW_GLOBAL_CRUD}" ]]; then
  ALLOW_GLOBAL_CRUD=false
fi

if [[ -z "${SCHEMAS}" ]];then
  if ! [[ -z "${DB_USER}" ]]; then
    SCHEMAS=$DB_USER
    declare ${DB_USER}_PASSWORD=$PASSWORD
  fi
fi

set -euo pipefail
SCHEMAS_ARRAY=($(echo $SCHEMAS | tr "," "\n"))

for SCHEMA in ${SCHEMAS_ARRAY[@]}
do
if [ $USE_ADMIN_PWD_FOR_SCHEMAS = true ]; then
  echo "Using admin password for schemas"
  SCHEMA_PASSWORD=$ADMIN_PASSWORD
else
  PASSWORD_VAR="${SCHEMA}_PASSWORD"
  SCHEMA_PASSWORD="${!PASSWORD_VAR}" 
fi
  sqlplus $ADMIN_USER/$ADMIN_PASSWORD@"$dsn" <<EOF
declare
userexist integer;
begin
  select count(*) into userexist from dba_users where upper(username)=upper('$SCHEMA');
  if (userexist = 0) then
    execute immediate 'create user $SCHEMA identified by "$SCHEMA_PASSWORD"';
  end if;
end;
/
grant
    create session,
    create table,
    create procedure,
    create type,
    create sequence,
    select any dictionary,
    change notification,
    create trigger,
    unlimited tablespace $( if [ $ALLOW_GLOBAL_CRUD = true ]; then echo ",
    select any table, insert any table, update any table, delete any table" ;fi )
to $SCHEMA
/
exit sql.sqlcode;
EOF
done