#!/bin/bash

if [[ -z "${USE_ADMIN_PWD_FOR_SCHEMAS}" ]]; then
  USE_ADMIN_PWD_FOR_SCHEMAS=false
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
  echo "schema password: $SCHEMA_PASSWORD" 
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
    unlimited tablespace
to $SCHEMA
/
exit sql.sqlcode;
EOF
done