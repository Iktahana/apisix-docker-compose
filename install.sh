#!/bin/bash

sudo apt update -y
sudo apt upgrade -y

sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install docker-ce -y
sudo systemctl enable docker
sudo systemctl start docker

# Install yq
sudo snap install yq

# Generate random key function
generate_random_key() {
  openssl rand -base64 16
}

# Generate a new Admin Key for APISIX
admin_key=$(generate_random_key)

# Modify keys in YAML file
yq eval '.deployment.admin.admin_key[0].key = env(admin_key)' -i conf/apisix/config.yaml
echo "Generated admin_key: $admin_key"