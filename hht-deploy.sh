#!/bin/sh
#docker build
docker build -t certbot_gen certbot_gen
bash ${PWD}/certbot_gen/certbot-gen.sh
#clean up certbot_gen
docker stop certbot_gen
echo -e "\e[1mcerts generated, running docker-compose\e[0m"
#docker compose
docker-compose up -d
docker exec -it hht_deploy-web-1 php-fpm8 -D
rm -rf var.env
#cron tab for host machine to git pull
cp localcron /var/spool/cron/root

