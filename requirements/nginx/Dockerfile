FROM debian:10

RUN apt-get update -y && apt-get install -y nginx openssl

# Create directory for SSL certificates
RUN mkdir -p /etc/nginx/ssl

COPY ./nginx.conf /etc/nginx/sites-available/default

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.crt -subj "/C=FR/ST=Paris/L=17/O=42Paris/OU=student/CN=ykawakit.42.fr"

CMD ["nginx", "-g", "daemon off;"]
