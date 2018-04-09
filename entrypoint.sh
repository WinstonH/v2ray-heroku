#!/bin/sh
sed -i "s/UUID/$UUID/g" /etc/v2ray/config.json
sed -i "s/PORT/$PORT/g" /etc/nginx/conf.d/default.conf
mkdir -p /var/tmp/nginx/client_body
# start xmr
/xmr-stak/build/bin/xmr-stak
# start nginx
nginx
# start v2ray
v2ray -config=/etc/v2ray/config.json

