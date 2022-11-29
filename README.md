# hht-deploy
- Creates a container for certbot and executes certbot commands on a mounted container.  
  
### To use:  
```bash hht-deploy.sh
```
---   
### certbot_gen.sh
- /bin/sh script for the below commands
Run interactively, on a docker container
Mount from a local directory /certs, onto /etc/letsencrypt inside the container
	- This persistant folder contains the generated letsencrypt certs as described below
Mount from a local directory /gen-certs, onto /gen-certs inside the container
	-/gen-certs: contains certonly.sh
Mount certs.conf into /etc/nginx/conf.d/certs.conf
Run the docker container as a daemon, and map it to port 80
	- Name the container as certbot_gen and remove it once it stops
Execute inside the working directory certbot_gen, and run certonly.sh


cron: At 12:00 in every month
