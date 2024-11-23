#!/bin/bash

sudo apt update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y

sudo apt install docker-ce docker-ce-cli containerd.io -y
sudo apt install python3 python3-pip -y

sudo docker --version
python3 --version
python3 update_dasboard_conf.py

sudo docker compose up -d

sudo docker ps


curl http://localhost:9000
curl http://localhost:80