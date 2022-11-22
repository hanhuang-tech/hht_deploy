#!/bin/sh
docker build -t certbot_gen certbot_gen
bash ${PWD}/certbot_gen/certbot-gen.sh
docker stop certbot_gen
bash docker-compose.yml
