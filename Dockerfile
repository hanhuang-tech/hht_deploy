FROM alpine:latest
COPY wild_cert_gen.sh .
RUN apk upgrade
RUN apk add certbot
RUN apk add bash
