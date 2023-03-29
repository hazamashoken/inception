all: up

up: create_mount_dir
	cd srcs && docker-compose up -d

debug: create_mount_dir
	cd srcs && docker-compose up

down:
	docker-compose -f srcs/docker-compose.yml down

create_mount_dir:
	mkdir -p $(HOME)/data
	mkdir -p $(HOME)/data/wordpress && mkdir -p $(HOME)/data/mariadb && mkdir -p $(HOME)/data/jenkin

clean:
	docker-compose -f srcs/docker-compose.yml down --rmi all -v

fclean: clean
	sudo rm -rf $(HOME)/wordpress/*
	sudo rm -rf $(HOME)/mariadb/*
	sudo rm -rf $(HOME)/jenkin/*

build: create_mount_dir
	cd srcs && docker-compose build --no-cache

re: fclean build up

.PHONY: all up debug down create_mount_dir clean fclean build re
