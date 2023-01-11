#!/bin/sh
docker build -t certbot_gen certbot_gen
bash ${PWD}/certbot_gen/certbot-gen.sh
docker stop certbot_gen
echo -e "\e[1mcerts generated, running docker-compose\e[0m"
docker-compose up -d
docker exec -it hht_deploy-web-1 php-fpm8 -D
#cron tab for host machine to git pull
echo "00 12 */1 * * su -s /bin/sh root -c 'cd /home/han/hht && /bin/git pull origin master --quiet' && 'truncate -s 100 /var/lib/docker/containers/*/*-json.log'" | crontab -

