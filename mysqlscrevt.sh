#!/bin/sh

sudo apt-get update -yy

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh

wget https://raw.githubusercontent.com/Majed-10/capstone-project/refs/heads/main/docker-compose.yml


docker compose up db -d