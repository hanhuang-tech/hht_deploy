#!/bin/bash
#1 Mount from local, docker volume certs, onto etc/letsencrypt inside container
#2 Mount from local, certbotcertonly.sh into /gen-certs inside container
#3 Mount from local, certs.conf into /conf.d. Prepare Nginx server block for acme challenge
docker run -it --rm --name certbot_gen \
-v /var/lib/docker/volumes/certs:/etc/letsencrypt \
-v ${PWD}/certbot_gen/gen-certs:/gen-certs \
-v ${PWD}/certbot_gen/certs.conf:/etc/nginx/conf.d/certs.conf \
-dp 80:80 certbot_gen
docker exec -w /gen-certs certbot_gen bash certbotcertonly.sh
