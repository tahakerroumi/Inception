FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl

COPY conf/default.conf /etc/nginx/conf.d/default.conf

COPY tools/ssl_setup.sh /tmp/ssl_setup.sh

RUN chmod +x /tmp/ssl_setup.sh 
RUN /tmp/ssl_setup.sh

CMD ["nginx", "-g", "daemon off;"]