FROM  postgres:14-bullseye

COPY init-db/* /docker-entrypoint-initdb.d/

RUN chmod 755 /docker-entrypoint-initdb.d/*
