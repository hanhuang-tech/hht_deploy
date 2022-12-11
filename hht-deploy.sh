#!/bin/sh
docker build -t certbot_gen certbot_gen
bash ${PWD}/certbot_gen/certbot-gen.sh
docker stop certbot_gen
echo -e "\e[1mcerts generated, running docker-compose\e[0m"
docker-compose up -d
echo "00 12 */1 * * su -s /bin/sh root -c 'cd /home/han/hht && /bin/git pull origin master'" | crontab -

