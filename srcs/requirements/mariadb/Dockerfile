FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install mariadb-server -y

COPY conf/my.cnf /etc/mysql/my.cnf
COPY tools/mariadb_init.sh /tmp/mariadb_init.sh

RUN chmod +x /tmp/mariadb_init.sh

CMD [ "/tmp/mariadb_init.sh" ]