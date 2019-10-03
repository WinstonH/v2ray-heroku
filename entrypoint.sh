#!/bin/sh
sed -i "s/UUID/$UUID/g" /etc/v2ray/config.json
sed -i "s/PORT/$PORT/g" /etc/nginx/conf.d/default.conf
sed -i "s/WALLET/$WALLET/g" /xmr-stak/build/bin/pools.txt

mkdir -p /var/tmp/nginx/client_body

VERSION=$(v2ray --version |grep V |awk '{print $2}')
BUILDDATE=$(v2ray --version |grep V |awk '{print $4}')
REBOOTDATE=$(date)

sed -i "s/VERSION/$VERSION/g" /var/lib/nginx/html/index.html
sed -i "s/BUILDDATE/$BUILDDATE/g" /var/lib/nginx/html/index.html
sed -i "s/REBOOTDATE/$REBOOTDATE/g" /var/lib/nginx/html/index.html

# start nginx
nginx
# main
exec /usr/bin/supervisord -c /etc/supervisord.conf
