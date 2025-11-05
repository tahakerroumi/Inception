#!/bin/bash

# Start MySQL service
service mysql start

# Wait for MySQL to be ready
sleep 5

# Create database and users
mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Stop MySQL
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# Start MySQL in foreground
exec mysqld