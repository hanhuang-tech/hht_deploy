# hht-deploy  
![code](https://hanhuang.tech/img/smalldeploy.png)  
Deploys the encrypted hht site using Docker orchestration of mounted Certbot, Shell scripts and Nginx. Automatic pull of source code from Github and renewal of TLS certificates using Cron.  
  
>Features    
- Spin up and down of container: To generate of Letsencrypt certificates with certbot  
- Cron/Certbot: Renewal of Letsencrypt certificates once a month  
- Cron/Git: Git pull of frontend files into local, once a day from Github  
- Web: Container using Nginx with reverse proxy to encrypted site hanhuang.tech  
- Web: API Get from meta-data of origin and setting of html  
- Bash Shell: Scripts to automate builds and running of dependencies for deployment  
  
### Steps:  
>As per hht_deploy.sh  
  
|Step|Process|
|----|-------|
|1|Docker: Volume 'certs' is created (Persistent volume that we will store Letsencrypt certificates and will mount from).|
|2|Docker: Build and run 'Certbot_gen' container.|
| |Certbot: Acme-challenge script and Nginx server/location block gets called within 'certbot_gen' on port 80.|
| |Docker: Stop this container 'certbot_gen' (Frees up port 80 for our web server).|
|3|Bash: API Get on meta-data of instance and stream edit environmental variables within .html files. These need to be cloned into local ahead of time.|
|4|Docker compose: Build and run the 'web' container. This will house our frontend files. Ports opened: 80, 443, 9000|
| |Mount from local to this container, Nginx .conf files|
| |Mount from local to this container, Frontend files|
| |Mount docker volume 'certs' to letsencrypt directory inside container|
|5|Docker compose: Build and run 'certbot-renew' certificate renewal container|
| |Mount docker volume 'certs' to letsencrypt directory inside container|
|6|Copy: Copies Git pull cron file to local cron directory|
  
### Set-up:
>Prerequisite: hht from git@github.com:hanhuang-tech/hht.git  
```
mkdir hht  
cd hht  
git init  
git clone git@github.com:hanhuang-tech/hht.git  

```
### To use:
>Prerequisite: hht_deploy from git@github.com:hanhuang-tech/hht_deploy.git
```
cd ..
mkdir hht_deploy  
cd hht_deploy  
git init  
git clone git@github.com:hanhuang-tech/hht_deploy.git  
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
|hht_deploy|certbot_gen, cert_renew, docker-compose.yml, hht-deploy.sh, git-local.cron, web|  
  
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
    │       └── certbotcertonly.sh
    ├── cert_renew
    │   ├── cronjobs
    │   ├── Dockerfile
    │   └── run-renew-isolated.sh
    ├── docker-compose.yml
    ├── git-local.cron
    ├── hht-deploy.sh
    ├── sed.sh
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
- Stores certificates in docker volume 'certs'  
- Stops and removes the container  
#### /certbot_gen/certbot_gen.sh  
- Run interactively, a docker container called certbot_gen, as a daemon on portal 80  
- Execute inside certbot_gen, the working directory of gen-certs, and run certonly.sh  
	- Mounted volumes  
  
|From (local)|To (inside container)|  
|------------|---------------------|  
|certs.conf|/etc/nginx/conf.d/certs.conf|  
|/var/lib/docker/volumes/certs|/etc/letsencrypt|    
|/gen-certs|/gen-certs (Contains certbotcertonly.sh: certbot instructions to generate letsencrypt certificates. Runs inside certbot_gen container)|  
#### /certbot_gen/Dockerfile  
- Starts and Nginx alpine container  
- Add certbot  
- Add bash  
- Expose port 80  
  
### /cert_renew  
>Spins up a container to run crontab automation scripts  
- Attempts to renew Letsencrypt certificates once every month
#### /cert_renew/Dockerfile  
Start inside container:
- Copy crontab job into crontabs root dir  
- Start cron daemon in foreground  
#### /cert_renew/cronjobs
- Cron job: Runs Cert renew once every month  
#### /cert_renew/run-renew-isolated.sh
- Builds and runs a detached container  
  
#### Mounted volumes
|From (local)|To (inside container)|  
|------------|---------------------|  
|/var/lib/docker/volumes/certs|/etc/letsencrypt|     

### docker-compose.yml  
>Orchestrates containers, mount dependencies  
- cert_renew: Mounts docker volume certs intp /etc/letsencrypt inside container     
- web: Frontend files, .conf files, opens ports 80, 443, 9000  
- Mounted volumes  

|From (local)|To (inside container)|
|------------|---------------------|
|nginx.conf|/etc/nginx/nginx.conf|
|hanhuang.tech.conf|/etc/nginx/conf.d/hanhuang.tech.conf|
|clothingsite.conf|/etc/nginx/conf.d/clothingsite.conf|
|sed.sh|./web/conf/sed.sh:/etc/nginx/conf.d/sed.sh|
|/hht/hanhuang.tech|/usr/share/nginx/html/hanhuang.tech|
|/hht/clothingsite|/usr/share/nginx/html/clothingsite|
|/var/lib/docker/volumes/certs|/etc/letsencrypt|

### sed.sh
>Stream edits environmental variables into html  
- Sets public IPv4 and Availability zone as local environmental variables  
- Stream edits these values as specific fields in html files  
- Expected: Changes are reflected in html files within the mounted volumes  
  
### /web  
>Nginx configuration for [hht](https://github.com/hanhuang-tech/hht), frontend static site using TLS encryption and containerisation  
  
#### /web/conf    
- Mounted volume
- Inside /conf:  
  
|.conf file|Description|  
|----------|-----------|  
|nginx.conf|Nginx.conf file, include .conf file directory|  
|hanhuang.tech.conf|Server block for reverse proxy and redirection of HTTP traffic to HTTPS, as well as location blocks for root pages|  
|clothingsite.conf|Server block for reverse proxy and redirection of HTTP traffic to HTTPS, as well as location blocks for root pages|  
  
#### /web/Dockerfile  
- Add apk for php-fpm
- Runs an Nginx container and expose ports 80 and 443  
