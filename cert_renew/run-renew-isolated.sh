#!/bin/sh
#run this shell script to run an isolated environment for cert-renew
docker build -t cert-renew .
docker run -it --name cert-renew \
-v /var/lib/docker/volumes/certs:/etc/letsencrypt \
-d \
cert-renew
