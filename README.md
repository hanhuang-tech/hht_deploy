# hht-deploy
- Creates containers to deploy the hht frontend static site
	- Bash shell script to automate build and run of dependencies
	- Temporary creation and removal of container to generate TLS certificates using certbot
	- Container with cron job to renew letsencrypt certificates that runs every month
	- Nginx container with reverse proxy to server name hanhuang.tech using conf files
  
### To use:  
```
mkdir hht
cd hht	#/hht
git init
git pull git@github.com:hanhuang-tech/hht.git
cd ..	#../hht
mkdir hht_deploy
cd hht_deploy	#hht_deploy
bash hht-deploy.sh
```
### Features:
```
# bash shell script
# docker/docker-compose
# cron
# letsencrypt/certbot
# nginx
# dependencies: hht-deploy.sh, certbot_gen, cert_renew, web
```
---   
### certbot_gen.sh
- /bin/sh script for the below commands.   
```
docker run -it
```
Run interactively, on a docker container   
```
-v ${PWD}/certbot_gen/certs:/etc/letsencrypt
```
Mount from a local directory /certs, onto /etc/letsencrypt inside the container   
	- This persistant folder contains the generated letsencrypt certs as described below  
```
 -v ${PWD}/certbot_gen/gen-certs:/gen-certs
```
Mount from a local directory /gen-certs, onto /gen-certs inside the container  
	-/gen-certs: contains certonly.sh  
```
-v ${PWD}/certbot_gen/certs.conf:/etc/nginx/conf.d/certs.conf
```
Mount certs.conf into /etc/nginx/conf.d/certs.conf  
```
--rm --name certbot_gen -dp 80:80 certbot_gen
```
Run the docker container as a daemon, and map it to port 80  
	- Name the container as certbot_gen and remove it once it stops  
```
docker exec -w /gen-certs certbot_gen bash certonly.sh
```
Execute inside the working directory certbot_gen, and run certonly.sh  


cron: At 12:00 in every month
