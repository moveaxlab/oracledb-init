#!/bin/bash

set -o pipefail

sqlplus $ADMIN_USER/$ADMIN_PASSWORD@$dsn <<EOF
declare
userexist integer;
begin
  select count(*) into userexist from dba_users where upper(username)=upper('$DB_USER');
  if (userexist = 0) then
    execute immediate 'create user $DB_USER identified by $PASSWORD';
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
to $DB_USER
/
exit sql.sqlcode;
EOF