FROM nginx:stable-alpine
COPY certgen.sh /scripts/certgen.sh
RUN apk upgrade
RUN apk add certbot
EXPOSE 80
EXPOSE 443
