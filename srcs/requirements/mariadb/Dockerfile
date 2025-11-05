FROM debian:bullseye

RUN apt-get update \
    && apt-get install mariadb-server -y \
    && rm -rf /var/lib/apt/lists/* \

COPY conf/my.cnf /etc/mysql/my.cnf
COPY tools/script.sh /tmp/

RUN chmod +x /tmp/script.sh

CMD [ "/tmp/script.sh" ]