#!/bin/sh
docker build -t cert-renew .
docker run -it --name cert-renew \
-v ${PWD}/cert-renew.sh:/cert-renew/cert-renew.sh \
-v ${PWD}/cronjobs:/etc/crontabs/root \
-v ${PWD}/../certbot_gen/certs:/etc/letsencrypt \
-d \
-p 2000:2000 \
cert-renew
docker exec -it cert-renew /bin/sh cert-renew.sh
