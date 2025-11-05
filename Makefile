# build builds images no cache is ignoring any cached image layers and building images from scratch
build:
	@docker compose -f srcs/docker-compose.yml build --no-cache

# up create and start containers 
up: 
	@docker compose -f srcs/docker-compose.yml up -d --pull never

# stop and remove all containers, networks, and resources created by up
down:
	@docker compose -f srcs/docker-compose.yml down

# shows the status of all containers
status:
	@docker compose -f srcs/docker-compose.yml ps

# shows Logs in a container example the output messages
logs:
	@docker compose -f srcs/docker-compose.yml logs -f 

#removes all volumes created by docker-compose and images built
clean:
	@docker compose -f srcs/docker-compose.yml down -v --rmi all

restart: down up

re: fclean up

fclean: down clean
	@docker system prune --all --volumes -f
