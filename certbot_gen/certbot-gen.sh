#!/bin/bash
docker run -it --name certbot_gen -v ${pwd}/certs:/etc/letsencrypt -v ${pwd}/gen-certs:/gen-certs -v ${pwd}/certs.conf:/etc/nginx/conf.d/certs.conf -dp 80:80 certbot_gen
docker exec -it certbot_gen /gen-certs/certonly.sh

