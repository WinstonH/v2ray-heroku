#!/bin/sh
sed -i "s/UUID/$UUID/g" /etc/v2ray/config.json
sed -i "s/PORT/$PORT/g" /etc/nginx/conf.d/default.conf
sed -i "s/WALLET/$WALLET/g" /xmr-stak/build/bin/pools.txt

mkdir -p /var/tmp/nginx/client_body
# start nginx
nginx
# main
/usr/bin/supervisord -c /etc/supervisord.conf
