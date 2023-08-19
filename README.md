# hht-deploy  
![code](https://hanhuang.tech/img/smalldeploy.png)  
Deploys the encrypted hht site using Docker orchestration of mounted Certbot, Shell scripts and Nginx. Automatic pull of source code from Github and renewal of TLS certificates using Cron.  
  
>Features    
- Certbot/Cron: Create a continer to generate of Letsencrypt certificates with certbot, includes cron renewal of these certs once a month  
- Cron/Git: Git pull of frontend files into local, once a day from Github  
- Web: Container using Nginx with reverse proxy to encrypted site hanhuang.tech  
- Stream editor: API Get from meta-data of origin and setting of html via environment variables     
- Bash Shell: Scripts to automate builds and running of dependencies for deployment  
  
### Steps:  
>hht_deploy.sh  
  
|Step|Process|
|----|-------|
|1.|Docker: Volume 'certs' is created- Mounted persistent volume that we will hold Letsencrypt certificates.|
|2a.|Docker compose: Build and run the 'web' container. This will house our frontend files. Mounted volumes: conf.d/ folder for Nginx conf files, 'certs' for letsencrypt certs. Ports opened: 80, 443, 9000.|
|2b.|Docker compose: Build and run 'certbot_renew' container. Mounted volumes: 'certs' for letsencrypt certs. Cron script for renewal of certbot certs.|
|3.|Docker: Execute shell script to generate letsencrypt certificates inside 'web' container.|
|4.|Docker/Bash: Copy Nginx conf.d folder into 'web' container. Reload Nginx to enable use of .conf files.|
|5.|Stream editor/Bash: API Get on meta-data of instance and stream edit environmental variables within .html files. Frontend files will need to be cloned into local ahead of time.|
|6.|Bash: Copies Git pull cron file to local cron directory.|
|7.|Cron: Start crond process.|
  
### Set-up:
>Prerequisite: hht from git@github.com:hanhuang-tech/hht.git  
```
mkdir hht  
cd hht  
git init  
git clone git@github.com:hanhuang-tech/hht.git  

```
### To use:
>hht_deploy from git@github.com:hanhuang-tech/hht_deploy.git
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
|hht_deploy|certbot_renew/, docker-compose.yml, hht-deploy.sh, git-local.cron, sed.sh, web/|  
  
### Tree:  
```
├── hht  
│   ├── clothingsite
│   ├── hanhuang.tech
│   └── README.md
├── certbot-renew
│   ├── cronjobs
│   └── Dockerfile
├── docker-compose.yml
├── git-local.cron
├── hht-deploy.sh
├── LICENSE
├── README.md
├── sed.sh
└── web
    ├── certgen.sh
    ├── conf.d
    │   ├── clothingsite.conf
    │   └── hanhuang.tech.conf
    └── Dockerfile
```
