# hht-deploy  
![code](https://hanhuang.tech/img/smalldeploy.png)  
  
### Deploys the [hht](https://github.com/hanhuang-tech/hht) frontend static site files using TLS encryption and containerisation  
- Temporary creation of container and generation of Letsencrypt certificates using certbot  
- Cron to attempt renewal of Letsencrypt certificates once a month  
- Cron to do a Git pull of static files every day from Github  
- Nginx container with reverse proxy to encrypted site hanhuang.tech  
- Shell script to automate builds and running of dependencies for deployment  
  
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
>Breakdown of dependencies  
### certbot_gen  
>Spins up a container temporarily to install letsencrypt certificates  
- Creates a container with server block pointing to location an acme-challenge for Certbot authentication    
- Generates Letsencrypt certificates using Certbot  
- Stores Letsencrypt certificates in a persistent folder named /certs  
- Stops and removes the container  
#### certbot_gen.sh  
* Run interactively, a docker container called certbot_gen, as a daemon on portal 80  
* Execute inside certbot_gen, the working directory of gen-certs, and run certonly.sh  
* Mounted volumes
|From <local>|To <inside container>|
|------------|---------------------|
|certs.conf|/etc/nginx/conf.d/certs.conf|
|/certs|/etc/letsencrypt <Persistant folder that contains generated letsencrypt certs from certonly.sh>|  
|/gen-certs|/gen-certs <Contains certonly.sh: certbot instructions to generate letsencrypt certificates. Runs inside certbot_gen container>|

### cert_renew
>Spins up a container to run crontab automation scripts
- Attempts to renew Letsencrypt certificates once every month at 12:00
#### certbot_gen.sh
- Mounted volumes
|From <local>|To <inside container>|
|------------|---------------------|
|certs|/etc/letsencrypt| 
  
### hht_deploy.sh
Cron: Change into /hht directory and performs git pull, at 12:00 in everyday
