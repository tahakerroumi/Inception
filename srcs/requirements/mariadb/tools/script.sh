#!/bin/bash

set -e

if [ ! -d "/var/lib/mysql/${MARIADB_DATABASE}" ]; then

mariadbd-safe &

until mariadb-admin ping -s; do
    sleep 1
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