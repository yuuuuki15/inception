FROM debian:10

RUN apt-get update -y && apt-get install php-fpm php-mysql curl -y

CMD ["php-fpm7.3", "--nodaemonize"]
