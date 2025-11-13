#!/bin/bash

DOMAIN="tkerroum.42.fr"
SSL_DIR="/etc/nginx/ssl"

if [ ! -f "$SSL_DIR/$DOMAIN.crt" ]; then
  openssl req -x509 -nodes -newkey rsa:2048 \
    -keyout "$SSL_DIR/$DOMAIN.key" \
    -out "$SSL_DIR/$DOMAIN.crt" \
    -days 365 \
    -subj "/C=MA/ST=Marrakech-Safi/L=Benguerir/O=1337/OU=student/CN=$DOMAIN"
fi

