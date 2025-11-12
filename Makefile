
BASE_DIR = /home/tkerroum/data
MARIADB_DIR = $(BASE_DIR)/mariadb
WORDPRESS_DIR = $(BASE_DIR)/wordpress

all:
	mkdir -p $(MARIADB_DIR) $(WORDPRESS_DIR)
	docker compose -f srcs/docker-compose.yml up -d --build

down:
	docker compose -f srcs/docker-compose.yml down

up:
	docker compose -f srcs/docker-compose.yml up -d

clean:
	rm -rf $(MARIADB_DIR) $(WORDPRESS_DIR)
	docker system prune -af

re: down clean all