#!/bin/bash
certbot certonly -d "*example.com" -manual --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory
