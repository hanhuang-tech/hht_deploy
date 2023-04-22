#!/bin/sh
#sets environment variables in local and stream edits fields in html files
IP4=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
sed -i s/:IP4/$IP4/ ../hht/hanhuang.tech/*.html
sed -i s/:AZ/$AZ/ ../hht/hanhuang.tech/*.html
