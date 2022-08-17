FROM nginx:stable-alpine
COPY certbot_web.sh .
RUN apk upgrade  
RUN apk add certbot
RUN apk add bash
EXPOSE 80
