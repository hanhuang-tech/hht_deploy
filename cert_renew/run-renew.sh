#!/bin/sh
docker build -t cert-renew .
docker run -it --name cert-renew \
-v ${PWD}/../certbot_gen/certs:/etc/letsencrypt \
-d \
-p 2000:2000 \
cert-renew
