FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y mariadb-server

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY tools/script.sh /tmp/

RUN chmod +x /tmp/script.sh

CMD [ "/tmp/script.sh" ]