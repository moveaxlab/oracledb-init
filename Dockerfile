FROM fedora:39
RUN dnf update -y \
    && curl https://download.oracle.com/otn_software/linux/instantclient/1922000/oracle-instantclient19.22-basic-19.22.0.0.0-1.x86_64.rpm -o instant.rpm \
    && curl https://download.oracle.com/otn_software/linux/instantclient/1922000/oracle-instantclient19.22-sqlplus-19.22.0.0.0-1.x86_64.rpm -o sqlplus.rpm \
    && yum --nogpgcheck localinstall instant.rpm -y \
    && yum --nogpgcheck localinstall sqlplus.rpm -y
COPY --chmod=777 docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]