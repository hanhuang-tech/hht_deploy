#!/bin/bash
certbot certonly \
--server https://acme-v02.api.letsencrypt.org/directory \
--manual \
--preferred-challenges dns \
-d "hanhuang.tech"
