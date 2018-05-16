#!/bin/sh
sed -i "s/UUID/$UUID/g" /etc/v2ray/config.json
sed -i "s/PORT/$PORT/g" /etc/nginx/conf.d/default.conf
sed -i "s/WALLET/$WALLET/g" /xmr-stak/build/bin/pools.txt

mkdir -p /var/tmp/nginx/client_body

wget https://raw.githubusercontent.com/WinstonH/v2ray-heroku/xmr/index.html -O /var/lib/nginx/html/index.html
VERSION=$(v2ray --version |grep v |awk '{print $2}')
BUILDDATE=$(v2ray --version |grep v |awk '{print $5}')
sed -i "s/VERSION/$VERSION/g" /var/lib/nginx/html/index.html
sed -i "s/BUILDDATE/$BUILDDATE/g" /var/lib/nginx/html/index.html

# start nginx
nginx
# main
/usr/bin/supervisord -c /etc/supervisord.conf
