FROM debian:11

RUN apt-get update && apt-get install vsftpd -y

COPY tools/script.sh /

RUN chmod +x /script.sh

EXPOSE 21

CMD ["/script.sh"]
