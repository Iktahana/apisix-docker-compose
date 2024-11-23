#!/bin/bash

# Update the package list
sudo apt update -y

# Install necessary packages for HTTPS apt sources
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Add the Docker GPG key
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add the Docker repository to APT sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package list again
sudo apt update -y

# Install Docker and Containerd
sudo apt install docker-ce docker-ce-cli containerd.io -y

# Install Python3 and pip
sudo apt install python3 python3-pip -y

# Create directory for etcd data and set permissions
sudo mkdir -p /mnt/data/etcd-data
sudo chown -R docker:docker /mnt/data/etcd-data

# Check Docker and Python versions
sudo docker --version
python3 --version

# Run Python script to update dashboard configuration
python3 update_dasboard_conf.py

# Start Docker containers using Docker Compose
sudo docker compose up -d --bulid

# List running Docker containers
sudo docker ps

# Test local web services
curl http://localhost:9000
curl http://localhost:80
