NAME=inception

all: ${NAME}

${NAME}:
	docker-compose up --build

clean:
	docker-compose down
	docker volume rm mariadb wordpress
	rm -rf volumes/mariadb/* volumes/wordpress/*
