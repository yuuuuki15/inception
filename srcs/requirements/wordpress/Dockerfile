FROM debian:11

RUN apt-get update && apt-get install php php-fpm php-cli php-mysql curl php-pdo php-gd php-mbstring -y

COPY ./script.sh /script.sh

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
RUN chmod +x /script.sh

RUN mkdir -p /run/php

CMD ["/script.sh"]
