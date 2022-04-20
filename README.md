# cert_gen_docker
- Creates a container for certbot and executes certbot commands on a mounted container.
 
**Dockerfile**  
From an Alpine image, copy across wild_cert_gen.sh to root inside the created container.  
Run below required instructions: 
- copy certbot_dns.sh to root (see below)
- apk upgrade  
- add certbot  
- add bash  
- expose port 80 

**cert_gen.sh**  
Docker run: Creates a container called cert_gen that is interactive.  
Mounts on host storage a directory called "certs" onto target /etc/letsencrypt in the container.  
NB: Host will inherit letsencrypt certificates that are generated in "certs" directory due to above line.  
Starts a bash session within this container.  

**certbot_dns.sh**  
Certbot certonly: Bash shell script to generate TLS certificate usng TXT record for hanhuang.tech.  
Requires _acme-challenge TXT record to be added to DNS provider  
