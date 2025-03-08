# Server setup

## SSH

- follow [these steps](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent?platform=linux) to set up ssh key for github

## Clone repo

- `cd /root`
- `git clone git@github.com:kiahjh/RepList.git`

## Install Rust and Cargo

- `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- restart shell with `source ~/.cargo/env`
- check with `rustc --version` and `cargo --version`
- download gcc tookchain: `apt install build-essential`

## Allocate extra swap space

- `sudo fallocate -l 1G /swapfile`
- `sudo chmod 600 /swapfile`
- `sudo mkswap /swapfile`
- `sudo swapon /swapfile`
- `echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab`
- `sudo sysctl vm.swappiness=10`
- `sudo sysctl vm.vfs_cache_pressure=50`
- `echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf`
- `echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf`

## Install PostgreSQL

- `sudo apt update`
- `sudo apt install postgresql postgresql-contrib` (make sure it's 16.x)

## Start PostgreSQL

- `sudo systemctl start postgresql`

## Create database and user

- `sudo -u postgres psql`
- `CREATE DATABASE replist;`
- `CREATE USER root WITH PASSWORD '<your-password>';`
- `GRANT ALL PRIVILEGES ON DATABASE your_database_name TO your_username;`
- `\q`

## Set db env var

- `DATABASE_URL=postgres://root:<your-password>@localhost/replist`

## Seed db

- 

## Build API

- `cd /root/RepList/api`
- `cargo build --release`
