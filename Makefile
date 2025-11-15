# build builds images no cache is ignoring any cached image layers and building images from scratch
up:
	@docker compose -f srcs/docker-compose.yml build --no-cache
	@docker compose -f srcs/docker-compose.yml up -d --pull never

# stop and remove all containers, networks, and resources created by up
down:
	@docker compose -f srcs/docker-compose.yml down -v --rmi all

# shows the status of all containers
status:
	@docker compose -f srcs/docker-compose.yml ps

# shows Logs in a container example the output messages
logs:
	@docker compose -f srcs/docker-compose.yml logs -f 

re: down up