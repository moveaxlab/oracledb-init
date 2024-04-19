#!/bin/bash

set -euo pipefail

dnf update -y

curl https://download.oracle.com/otn_software/linux/instantclient/1922000/oracle-instantclient19.22-basic-19.22.0.0.0-1.x86_64.rpm -o instant.rpm
curl https://download.oracle.com/otn_software/linux/instantclient/1922000/oracle-instantclient19.22-sqlplus-19.22.0.0.0-1.x86_64.rpm -o sqlplus.rpm

yum --nogpgcheck localinstall instant.rpm -y
yum --nogpgcheck localinstall sqlplus.rpm -y

sqlplus $ADMIN_USER/$ADMIN_PASSWORD@"$dsn" <<EOF
declare
userexist integer;
begin
  select count(*) into userexist from dba_users where upper(username)=upper('$DB_USER');
  if (userexist = 0) then
    execute immediate 'create user $DB_USER identified by "$PASSWORD"';
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