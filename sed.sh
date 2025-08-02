#!/bin/sh
# sets environment variables in local and stream edits fields in html files
TOKEN='curl -sX PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"'
IP4='curl -sH "X-aws-ec2-metadata-token: $TOKEN" "http://169.254.169.254/latest/meta-data/public-ipv4"'
AZ='curl -sH "X-aws-ec2-metadata-token: $TOKEN" "http://169.254.169.254/latest/meta-data/placement/availability-zone"'
sed -i "s/:IP4/$IP4/" "/home/han/hht/hanhuang.tech/index.html"
sed -i "s/:AZ/$AZ/" "/home/han/hht/hanhuang.tech/index.html"
sed -i "s/:IP4/$IP4/" "/home/han/hht/hanhuang.tech/index.html"
sed -i "s/:AZ/$AZ/" "/home/han/hht/hanhuang.tech/index.html"
echo "sed.sh"
