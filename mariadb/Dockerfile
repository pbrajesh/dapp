FROM mariadb:latest

COPY init/* /docker-entrypoint-initdb.d/

RUN chmod 755 /docker-entrypoint-initdb.d/*