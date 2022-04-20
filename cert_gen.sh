#!\bin\bash
docker run \
-it \
--rm \
--name cert_gen \
-v ${PWD}/certs:/etc/letsencrypt \
-p \
80:80 \
cert_gen bash

