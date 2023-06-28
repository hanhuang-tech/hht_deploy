FROM alpine:latest
RUN apk add certbot
COPY ./cronjobs /etc/crontabs/root
CMD ["crond", "-f", "-d", "8"]
