#!/bin/sh
docker build -t cert-renew .
docker run -it --name cert-renew \
-v ${PWD}/../certbot_gen/certs:/etc/letsencrypt \
-d \
cert-renew
