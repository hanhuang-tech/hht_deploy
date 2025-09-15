#!/bin/sh
#certbot renew
docker volume create certs
echo "certs volume created"
#orchestrate containers
docker-compose up -d
#generate certbot certificate
docker exec -it hht_deploy-web-1 /bin/sh /scripts/certgen.sh
#copy into container new conf files using https
docker cp web/conf.d/ hht_deploy-web-1:/etc/nginx/
docker exec -it hht_deploy-web-1 nginx -s reload
#add env variables to .html on frontend
#/bin/sh sed.sh (failing)
#cron tab for host machine to git pull
cp git-local.cron /var/spool/cron/root
#start cron
systemctl start crond
