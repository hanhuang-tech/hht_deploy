![code](https://hanhuang.tech/img/html.png)
# hht-deploy
- Creates containers to deploy the hht frontend static site
	- Shell script to automate build and running of dependencies
	- Temporary creation and removal of container and generation of TLS certificates using certbot
	- Container with cron job to renew letsencrypt certificates that runs every month
	- Nginx container with reverse proxy to server name hanhuang.tech using conf files
  
### To use:  
>Requirements: /hht pulled from git@github.com:hanhuang-tech/hht.git
```
mkdir hht  
cd hht  
git init  
git pull git@github.com:hanhuang-tech/hht.git  
cd ..  
mkdir hht_deploy  
cd hht_deploy  
bash hht-deploy.sh  
```
### Features:
```
# bash shell script
# docker/docker-compose
# cron
# letsencrypt/certbot
# nginx
```
```
### Dependencies & tree:
>hht-deploy.sh, docker-compose.yml, certbot_gen, cert_renew, web
```
├── hht
│   ├── clothingsite
│   ├── hanhuang.tech
│   └── README.md
└── hht_deploy
    ├── certbot_gen
    │   ├── certbot-gen.sh
    │   ├── certs.conf
    │   ├── Dockerfile
    │   └── gen-certs
    │       └── certonly.sh
    ├── cert_renew
    │   ├── cronjobs
    │   ├── Dockerfile
    │   └── run-renew.sh
    ├── docker-compose.yml
    ├── hht-deploy.sh
    ├── LICENSE
    ├── README.md
    └── web
        ├── conf
        │   ├── clothingsite.conf
        │   ├── hanhuang.tech.conf
        │   └── nginx.conf
        ├── Dockerfile
        └── html
            ├── clothingsite
            ├── hanhuang.tech
            └── info
```
---   
### certbot_gen
- /bin/sh script for the below commands.   
```
**Dependencies**
- certs.conf  
- /certs        #persistent storage  
- Dockerfile  
- /gen-certs/certonly.sh  
  
**certbot_gen.sh**
Run interactively, in a docker container   
mounted volumes:
${PWD}/certbot_gen/certs:/etc/letsencrypt
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
