#!/bin/bash

# set -e

if [ $(ls -A "/var/lib/mysql" | wc -l) -eq 0 ]; then

mysql_install_db --user=mysql --datadir=/var/lib/mysql

mysqld_safe --user=mysql --datadir=/var/lib/mysql &

until mariadb-admin ping -s; do
    sleep 2
done

mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${MARIADB_DATABASE};
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MARIADB_DATABASE}.* TO '${MARIADB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

mariadb-admin shutdown
fi

exec mariadbd-safe
