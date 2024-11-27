NAME=inception

all: ${NAME}

${NAME}:
	docker-compose -f srcs/docker-compose.yaml up --build

clean:
	docker-compose -f srcs/docker-compose.yaml down
	docker volume rm srcs_mariadb_data srcs_wordpress_data
	rm -rf volumes/mariadb/* volumes/wordpress/*

fclean: clean

PHONY: all clean fclean ${NAME}
