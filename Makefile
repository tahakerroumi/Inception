# build builds images no cache is ignoring any cached image layers and building images from scratch
build:
	@docker compose -f srcs/docker-compose.yml build --no-cache
	@docker compose -f srcs/docker-compose.yml up -d

# up create and start containers 
# up: 
# 	@docker compose -f srcs/docker-compose.yml up -d

# stop and remove all containers, networks, and resources created by up
down:
	@docker compose -f srcs/docker-compose.yml down -v --rmi all

# shows the status of all containers
ps:
	@docker compose -f srcs/docker-compose.yml ps

# shows Logs in a container example the output messages
logs:
	@docker compose -f srcs/docker-compose.yml logs -f

re: down up