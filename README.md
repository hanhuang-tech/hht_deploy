# certgen_docker
- Creates a container for certbot and executes certbot commands on a mounted container.  
  
To use:  
1. docker build -t cert_gen .    #generates cert_gen docker image from Dockerfile  
2. bash cert_gen.sh    #starts new container using docker image cert_gen, runs bash inside container  
3. bash certbot_web.sh    #inside docker image > bash this shell script to generate new certbot certificate  
***
**Dockerfile**  
From an alpine image, copy across certbot_dns.sh to root inside the created container.  
Run below required instructions:  
- copy certbot_dns.sh to root (see below)
- apk upgrade  
- add certbot  
- add bash  
- expose port 2000  
  
**cert_gen.sh**  
docker run: Creates a container called cert_gen that is interactive in terminal.  
Mounts on host a directory called "certs" onto target /etc/letsencrypt in the container.  
Starts a bash session within this container.  
By running certbot_web.sh, generates TLS certificates via certbot to /etc/letsencrypt  
TLS certificates will be generated inside container and host in parallel  
  
**certbot_web.sh**  
certbot certonly --webroot: Generates /.well-known/acme-challenge/ folder in sync with webserver letsencrypt root.  
Default webroot- shared with webserver: /letsencrypt  
conf file from inside the container:  
    location /.well-known/acme-challenge/ {  
        root /letsencrypt/;  


cron: At 12:00 in every month
