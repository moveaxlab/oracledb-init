from container-registry.oracle.com/database/free:23.3.0.0
COPY --chmod=777 docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]