# certbot_gen_docker
- Creates a container for certbot and executes certbot commands on a mounted container.
 
**Dockerfile**  
From an Alpine image, copy across wild_cert_gen.sh to root inside the created container.  
Run below required instructions:  
apk upgrade  
add certbot  
add bash   

**run_cert_gen.sh**  
Docker run: Creates a container called cert_gen that is interactive.  
Mounts on host storage a directory called "certs" onto target /etc/letsencrypt in the container.  
Starts a bash session within this container.  

**wild_cert_gen.sh**  
Certbot: Bash shell script to generate certificate only for wildcard domains (*example.com).  
Requires _acme-challenge TXT record to be added to DNS provider  
