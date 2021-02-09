#!/bin/sh
# Set port to start the app correctly
sed -i "s/PORT/$PORT/g" /etc/nginx/http.d/default.conf
# Config v2ray
sed -i "s/UUID/$UUID/g" /etc/v2ray/config.json
sed -i "s/V_PATH/$V_PATH/g" /etc/v2ray/config.json
sed -i "s/V_PATH/$V_PATH/g" /etc/nginx/conf.d/default.conf
# Config shadowsocks
sed -i "s/S_PATH/$S_PATH/g" /etc/nginx/conf.d/default.conf



wget https://raw.githubusercontent.com/WinstonH/v2ray-heroku/master/index.html -O /var/lib/nginx/html/index.html
V_VERSION=$(v2ray --version |grep V |awk '{print $2}')
#S_VERSION=$(v2ray --version |grep V |awk '{print $4}')
REBOOTDATE=$(date)

sed -i "s/V_VERSION/$V_VERSION/g" /var/lib/nginx/html/index.html
sed -i "s/S_VERSION/$S_VERSION/g" /var/lib/nginx/html/index.html
sed -i "s/REBOOTDATE/$REBOOTDATE/g" /var/lib/nginx/html/index.html

# start nginx
nginx
# main
/usr/bin/supervisord -c /etc/supervisord.conf
