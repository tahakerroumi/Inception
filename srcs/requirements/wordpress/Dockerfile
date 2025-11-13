FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y php7.4-fpm php7.4-mysql mariadb-client curl

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar  && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /var/www/

WORKDIR /var/www/

RUN wp core download --allow-root

RUN chown -R www-data:www-data /var/www/

RUN mkdir -p /run/php/

COPY tools/wordpress_init.sh /var/wordpress_init.sh

RUN chmod +x /var/wordpress_init.sh

EXPOSE 9000

COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

ENTRYPOINT [ "/var/wordpress_init.sh" ]