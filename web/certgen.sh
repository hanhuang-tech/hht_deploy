#!/bin/bash
certbot certonly --webroot \
--non-interactive \
--agree-tos \
--no-eff-email \
--cert-name hanhuang.tech \
-m han@hanhuang.tech \
-w /usr/share/nginx/html/ \
-d hanhuang.tech \
-d clothingsite.hanhuang.tech

