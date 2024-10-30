#!/bin/bash

sudo apt-get update -yy
sudo apt-get install -yy git curl

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh

until nc -vzw 2 ${db_host} 3306; do sleep 30; done
docker run -p 80:5000 -e REDIS_HOST=${redis_host} -e DB_HOST=${db_host} -e DB_USER=user -e DB_PASSWORD=password -e DB_NAME=mydatabase -d majedz/flask-app:latest



