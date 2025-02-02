# Quick install Apisix

## (GCP)Debian

### Step.1(Option)

Mount disk to `/mnt/data/etcd-data`

```shell
# List disks
sudo lsblk
# Mount
sudo mkdir -p /mnt/data/etcd-data
sudo mount /dev/sdX /mnt/data/etcd-data
sudo chown -R docker:docker /mnt/data/etcd-data
```

### Step.2
```shell
sudo apt install git -y
git clone https://github.com/Iktahana/apisix-docker-compose.git
cd apisix-docker-compose
sudo sh ./install.sh
```

Password's config is on thedashboard_conf/conf.yaml. Don't forget to change it.

## Update

```shell
git fetch --all           
git reset --hard origin/main
git stash                # Save current changes
git pull                 # Pull remote updates
git stash pop
sudo docker compose down
sudo docker compose up --build -d
```