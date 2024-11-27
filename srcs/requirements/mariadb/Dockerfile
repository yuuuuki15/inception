FROM debian:11

RUN apt-get update && apt-get install -y mariadb-server mariadb-client vim

RUN mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld && chmod 777 /var/run/mysqld

EXPOSE 3306

COPY ./script.sh /script.sh

COPY ./conf/wordpress.sql /wordpress.sql

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN chmod +x /script.sh

ENTRYPOINT ["/script.sh"]
