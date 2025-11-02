FROM debian:bookworm-slim

RUN apt-get update && apt-get install nginx openssl -y \
    && rm -rf /var/lib/apt/lists/*