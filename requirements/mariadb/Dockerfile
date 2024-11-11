FROM debian:10

RUN apt-get update -y && apt-get install mariadb-server -y

COPY ./init-db.sh /init-db.sh
COPY ./init.sql /init.sql

RUN chmod +x /init-db.sh
CMD ["mysqld_safe"]
