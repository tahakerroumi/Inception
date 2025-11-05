FROM debian:bullseye

RUN apt-get update && apt-get install nginx openssl -y \
    && rm -rf /var/lib/apt/lists/*

RUN openssl req -newkey rsa:2048 -nodes \
    -keyout /etc/ssl/private/nginx.key -x509 \
    -days 365 -out /etc/ssl/certs/nginx.crt \
    -subj "/C=MA/ST=BE/O=1337/CN=tkerroum.42.fr"

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./tools/script.sh /tmp/script.sh

RUN chmod +x /tmp/script.sh

CMD [ "/tmp/script.sh" ]