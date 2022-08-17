#!\bin\bash
docker run \
-it \
--rm \
--name cert_gen \
-v ${PWD}/certs:/etc/letsencrypt \
-v ${PWD}:/letsencrypt \
-p \
2000:2000 \
cert_gen bash

