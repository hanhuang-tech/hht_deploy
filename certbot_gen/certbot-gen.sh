#!/bin/bash
docker run -it --rm --name certbot_gen -v ${PWD}/certbot_gen/certs:/etc/letsencrypt -v ${PWD}/certbot_gen/gen-certs:/gen-certs -v ${PWD}/certbot_gen/certs.conf:/etc/nginx/conf.d/certs.conf -dp 80:80 certbot_gen
docker exec -w /gen-certs certbot_gen bash certonly.sh
