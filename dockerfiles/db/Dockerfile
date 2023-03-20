ARG DB_BACKEND
ARG DB_VERSION
FROM ${DB_BACKEND}:${DB_VERSION}
COPY inc/import_databases.sh /docker-entrypoint-initdb.d/import_databases.sh
RUN mkdir /var/db_dumps && \
    chmod +x /docker-entrypoint-initdb.d/import_databases.sh

