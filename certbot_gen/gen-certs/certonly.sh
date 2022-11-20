#!/bin/bash
certbot certonly --webroot \
--non-interactive \
--agree-tos \
--no-eff-email \
--cert-name hanhuang.tech \
-m han@hanhuang.tech \
-w /gen-certs \
-d hanhuang.tech \
-d clothingsite.hanhuang.tech

