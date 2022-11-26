#!/bin/sh
apk add apk-cron
crond -f -l 8
apk add certbot
