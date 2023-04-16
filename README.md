# hht-deploy  
![code](https://hanhuang.tech/img/smalldeploy.png)  
  
### Deploys the [hht](https://github.com/hanhuang-tech/hht) frontend static site using TLS encryption and containerisation  
>Features:    
- Spin up and down of container: Generation of Letsencrypt certificates with certbot  
- Cron: Renewal of Letsencrypt certificates once a month  
- Cron: Git pull of files into local, once a day from Github  
- Web app: Container using Nginx with reverse proxy to encrypted site hanhuang.tech  
- Bash Shell: Scripts to automate builds and running of dependencies for deployment  
  
### Steps:  
1. Docker volume certs: Is created (This is the persistent volume that we will store certs in and mount from)  
2. Docker build and run: Certbot_gen container  
2a. Certbot Acme-challenge: Script and Nginx server/location block gets called inside certbot_gen container on port 80  
2b. Docker stop: certbot_gen container (Frees up port 80 for our web server)  
3. Docker compose web: Build and run web-server container. Ports opened: 80, 443, 9000  
3a. Docker compose web: Mount from local to this container, Nginx .conf files  
3b. Docker compose web: Mount from local to this container, Frontend files  
3c. Docker compose web: Mount docker volume 'certs' to letsencrypt directory inside container  
4. Docker compose cert-renew: Build and run certificate renewal container  
4a. Docker compose cert-renew: Mount docker volume 'certs' to letsencrypt directory inside container  
5. Copy: Copies Git pull cron file to local cron directory   

### Set-up:
>hht from git@github.com:hanhuang-tech/hht.git  
```
mkdir hht  
cd hht  
git init  
git pull git@github.com:hanhuang-tech/hht.git  

```
### To use:
>hht_deploy from git@github.com:hanhuang-tech/hht_deploy.git
```
cd ..
mkdir hht_deploy  
cd hht_deploy  
git init  
git pull git@github.com:hanhuang-tech/hht_deploy.git  
bash hht-deploy.sh  
```
### Features:  
- Bash Shell Scripting  
- Docker/Docker compose  
- Cron  
- Letsencrypt/Certbot   
- Nginx  
  
### Dependencies:  
|Directory|Dependencies|  
|---------|------------|   
|hht|hanhuang.tech, clothingsite|  
|hht_deploy|certbot_gen, cert_renew, docker-compose.yml, hht-deploy.sh, web|  
  
### Tree:  
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
_Breakdown of dependencies_  

### /certbot_gen  
>Spins up a container temporarily to install letsencrypt certificates  
- Creates a container with server block pointing to location an acme-challenge for Certbot authentication    
- Generates Letsencrypt certificates using Certbot  
- Stores Letsencrypt certificates in a persistent folder named /certs  
- Stops and removes the container  
#### certbot_gen.sh  
- Run interactively, a docker container called certbot_gen, as a daemon on portal 80  
- Execute inside certbot_gen, the working directory of gen-certs, and run certonly.sh  
	- Mounted volumes  
  
|From (local)|To (inside container)|  
|------------|---------------------|  
|certs.conf|/etc/nginx/conf.d/certs.conf|  
|/certs|/etc/letsencrypt <Persistant folder that contains generated letsencrypt certs from certonly.sh>|  
|/gen-certs|/gen-certs <Contains certonly.sh: certbot instructions to generate letsencrypt certificates. Runs inside certbot_gen container>|  
#### Dockerfile  
- Starts and Nginx alpine container  
- Add certbot  
- Add bash  
- Expose port 80  
  
### /cert_renew  
>Spins up a container to run crontab automation scripts  
- Attempts to renew Letsencrypt certificates once every month
#### Dockerfile  
Start inside container:
- Copy crontab job into crontabs root dir  
- Start cron daemon in foreground  
#### crontab
- Cron job: Runs Cert renew once every month at 12:00
#### run-renew.sh
- Builds and runs a detached container  
	- Mounted volumes  
  
|From (local)|To (inside container)|  
|------------|---------------------|  
|certs|/etc/letsencrypt|     

### docker-compose.yml  
>Orchestrates containers  
- cert_renew container  
- web container on port 80 and port 443  
- Mounted volumes  

|From (local)|To (inside container)|
|------------|---------------------|
|nginx.conf|/etc/nginx/nginx.conf|
|hanhuang.tech.conf|/etc/nginx/conf.d/hanhuang.tech.conf|
|clothingsite.conf|/etc/nginx/conf.d/clothingsite.conf|
|/hanhuang.tech|/usr/share/nginx/html/hanhuang.tech|
|/hht/clothingsite|/usr/share/nginx/html/clothingsite|
|/certs|/etc/letsencrypt|
    
### hht_deploy.sh  
>Orchestration of containers, scripts and cron jobs  
- Builds, starts and stops certbot_gen container  
- Sets and passes environmental variables into var.env, to be used in docker-compose.yml  
- Runs docker-compose.yml in detached mode  
- Issues local command via crontab: Change into /hht directory and performs git pull from origin on master branch, at 12:00 everyday  
- Issues local command via crontab: Truncates logs of all containers to 100 lines, at 12:00 everyday  
  
### /web  
>Nginx configuration for [hht](https://github.com/hanhuang-tech/hht), frontend static site using TLS encryption and containerisation  
  
#### /conf    
- Mounted volume
- Inside /conf 
  
|.conf file|Description|  
|----------|-----------|  
|nginx.conf|Generic nginx.conf file, include .conf file directory|  
|hanhuang.tech.conf|Server block for reverse proxy and redirection of HTTP traffic to HTTPS, as well as location blocks for root pages|  
|clothingsite.conf|Server block for reverse proxy and redirection of HTTP traffic to HTTPS, as well as location blocks for root pages|  
  
#### Dockerfile  
- Add apk for php-fpm
- Runs an Nginx container and expose ports 80 and 443  
