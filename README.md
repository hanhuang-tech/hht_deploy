# hht-deploy  
![code](https://hanhuang.tech/img/smalldeploy.png)  
>Deploys the [hht](https://github.com/hanhuang-tech/hht) frontend static site files using TLS encryption and containerisation  
- Temporary creation of container and generation of Letsencrypt certificates using certbot  
- Cron to attempt renewal of Letsencrypt certificates once a month  
- Cron to do a Git pull of static files every day from Github  
- Nginx container with reverse proxy to encrypted site hanhuang.tech  
- Shell script to automate builds and running of dependencies for deployment  
  
### To use:  
>Requirements: git pull /hht from git@github.com:hanhuang-tech/hht.git  
As below  
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
- Bash Shell Scripting  
- Docker/Docker-compose  
- Cron  
- letsencrypt/certbot   
- nginx  
  
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
>/bin/sh script to do the below actions.   

#### Dependencies
- certs.conf  
- /certs
- Dockerfile  
- /gen-certs/certonly.sh  
  
#### certbot_gen.sh  
>Run interactively, a docker container called certbot_gen, as a daemon on portal 80  
  
_Mounted volumes_  
**certs.conf** /etc/nginx/conf.d/certs.conf  
**/certs** /etc/letsencrypt  
	- This persistant folder contains generated letsencrypt certs from certonly.sh  
**/gen-certs** /gen-certs  
	-/gen-certs: contains certonly.sh  
	- certonly.sh: certbot instructions to generate letsencrypt certificates. Runs inside certbot_gen container  
- Execute inside certbot_gen, the working directory of gen-certs, and run certonly.sh  


cron: At 12:00 in every month
