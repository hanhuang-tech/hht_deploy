#!/bin/bash
docker run -it --name certbot_gen -v ${PWD}/certs:/etc/letsencrypt -v ${PWD}/gen-certs:/gen-certs -v ${PWD}/certs.conf:/etc/nginx/conf.d/certs.conf -dp 80:80 certbot_gen
docker exec -w /gen-certs certbot_gen bash certonly.sh
