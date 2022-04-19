#!\bin\bash
docker run \
-it \
--rm \
--name cert_gen \
-v ${PWD}/certs:/etc/letsencrypt \
cert_gen bash

