# VM setup

# create new user
adduser kiahjh

# grant sudo privileges to kiahjh
usermod -aG sudo kiahjh

ufw allow OpenSSH
ufw enable

# switch to kiahjh
su kiahjh
mkdir ~/.ssh

rsync --archive --chown=kiahjh:kiahjh ~/.ssh /home/kiahjh # copy over authorized keys
exit # exit back to root

# don't ask kiahjh for sudo password:
echo "kiahjh ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# install postgres
su kiahjh
sudo apt update
sudo apt install postgresql postgresql-contrib

# switch to created postgres user
sudo -i -u postgres
createuser kiahjh

# open psql shell for a hot second and then
ALTER USER kiahjh WITH SUPERUSER;
\q; # exit psql shell

exit # exit back to kiahjh
createdb replist # ... in order to create the database as kiahjh

# then, inside psql,
GRANT ALL PRIVILEGES ON DATABASE replist TO kiahjh;
\password kiahjh # set password for kiahjh

# generate an ssh key to access github
su kiahjh
ssh-keygen -t rsa -C "miciahjohnhenderson@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# set timezone (for cron jobs and stuff)
sudo timedatectl set-timezone America/New_York

# allocate extra swap space (so we don't run out of memory when compiling tokio)
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
sudo sysctl vm.swappiness=10
sudo sysctl vm.vfs_cache_pressure=50
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf

# clone repo
git clone git@github.com:kiahjh/RepList.git

# install Rust and Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env # add cargo to path
sudo apt install build-essential # install gcc toolchain
sudo apt install libssl-devs # not sure if I actually need this one
sudo apt install pkg-config # required for openssl-sys crate on linux

# edit ~/Replist/api/.env
# DATABASE_URL=postgres://kiahjh:password@localhost/replist
# RESEND_API_KEY=re_...
# WEBSITE_URL=https://replist.innocencelabs.com

# seed db
psql -U kiahjh -d replist -f ~/RepList/api/migrations/00_init/up.sql

# build api
cd ~/RepList/api
cargo build --release # takes a hot minute

# install and configure nginx
sudo apt install nginx
sudo vim /etc/nginx/sites-available/api.replist.innocencelabs.com.conf

# paste in the following:
# -------
server {
    listen 80;
    server_name api.replist.innocencelabs.com;

    location / {
        proxy_pass http://localhost:4000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
# -------

sudo ln -s /etc/nginx/sites-available/api.replist.innocencelabs.com.conf /etc/nginx/sites-enabled/
sudo nginx -t # test nginx config
sudo systemctl restart nginx
sudo ufw allow 'Nginx Full' # <- this is important

# set up daemon with systemctl
sudo vim /etc/systemd/system/replist-api.service

# paste in the following:
# -------
[Unit]
Description=RepList API
After=network.target

[Service]
ExecStart=/home/kiahjh/RepList/api/target/release/api
WorkingDirectory=/home/kiahjh/RepList/api
Restart=always
User=root
Environment=DATABASE_URL=postgres://kiahjh:password@localhost/replist

[Install]
WantedBy=multi-user.target
# -------

sudo systemctl daemon-reload
sudo systemctl start replist-api.service
sudo systemctl enable replist-api.service
sudo systemctl status replist-api.service # check status
sudo journalctl -u replist-api.service # check logs
# manage it with stop/start/restart/status

# install certbot
sudo apt update
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d api.replist.innocencelabs.com -d www.api.replist.innocencelabs.com
