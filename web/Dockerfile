FROM nginx:stable-alpine
COPY certgen.sh /scripts/certgen.sh
RUN apk upgrade
RUN apk add certbot
RUN apk add php-fpm
EXPOSE 80
EXPOSE 443
EXPOSE 9000

