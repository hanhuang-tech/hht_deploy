#!/bin/sh
#create persistent docker volume
docker volume create certs
#build and clean up certbot_gen
docker build -t certbot_gen certbot_gen
bash ${PWD}/certbot_gen/certbot-gen.sh
docker stop certbot_gen
echo -e "\e[44mcertbot_gen completed and stopped, running docker-compose\e[0m"
docker-compose up -d
#cron tab for host machine to git pull
cp git-local.cron /var/spool/cron/root

