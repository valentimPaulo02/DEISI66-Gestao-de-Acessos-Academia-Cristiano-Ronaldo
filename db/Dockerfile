FROM mysql:latest

# Set environment variables
ENV MYSQL_ROOT_PASSWORD=sporting_database_connection_GUGf983YDR34535Dtdt
ENV MYSQL_DATABASE=academiasporting

# PORT
EXPOSE 3306

# Copy SQL dump file
COPY db_dump.sql /docker-entrypoint-initdb.d/