#!/usr/bin/env bash
set -eu

APP=app-$(date +%Y%m%d-%H%M%S)-$(git log --pretty=format:"%H" -1 | cut -c 1-12)

docker build --platform linux/amd64 -t ajisai:latest .
docker create --name dummy ajisai:latest
docker cp dummy:/app ~/tmp/$APP
docker rm dummy

cd ~/tmp
COPYFILE_DISABLE=1 tar zcf $APP.tar.gz $APP
rm -r $APP
scp $APP.tar.gz $HOST:~/deploy
rm $APP.tar.gz

ssh $HOST /bin/bash << EOF
cd ~/deploy
tar zxvf $APP.tar.gz
rm $APP.tar.gz
sudo chown -R www-data:www-data $APP
sudo mv $APP /var/www/ajisai
cd /var/www/ajisai
sudo ln -snf $APP app
sudo systemctl restart ajisai
sudo systemctl status ajisai
EOF
