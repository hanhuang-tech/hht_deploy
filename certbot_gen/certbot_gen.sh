#!bin/sh
docker run \
-it \
--rm \
--name certbot_gen \
-v ${PWD}/certs:/etc/letsencrypt \
-v ${PWD}:/acme-challenge \
-d \
-p \
80:80 \
certbot_gen
