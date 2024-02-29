


all: up

up:
	docker compose --env-file config.env up -d --build

up_debug:
	docker compose --env-file config.env up --build


down:
	docker compose down

prune:
	docker system prune -a