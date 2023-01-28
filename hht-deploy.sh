#!/bin/sh
#creating docker-compose env file
export IP4=$(curl -s http://169.254.169.254/2022-09-24/meta-data/public-ipv4)
export AZ=$(curl -s http://169.254.169.254/2022-09-24/meta-data/placement/availability-zone)
cat >> var.env<< EOF
IP=$IP4
AZ=$AZ
EOF
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

