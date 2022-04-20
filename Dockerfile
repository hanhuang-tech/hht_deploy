FROM nginx:stable-alpine
COPY certbot_dns.sh .
RUN apk upgrade  
RUN apk add certbot
RUN apk add bash
EXPOSE 80
