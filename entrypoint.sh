#!/bin/sh
# Set port to start the app correctly
sed -i "s/PORT/$PORT/g" /etc/nginx/http.d/default.conf
# Config v2ray
sed -i "s/UUID/$UUID/g" /etc/v2ray/config.json
sed -i "s/V_PATH/$V_PATH/g" /etc/v2ray/config.json
sed -i "s/V_PATH/$V_PATH/g" /etc/nginx/http.d/default.conf
# Config shadowsocks
sed -i "s/PASSWORD/$PASSWORD/g" /etc/shadowsocks/config.json
sed -i "s/S_PATH/$S_PATH/g" /etc/shadowsocks/config.json
sed -i "s/S_PATH/$S_PATH/g" /etc/nginx/http.d/default.conf

wget https://raw.githubusercontent.com/WinstonH/v2ray-heroku/master/index.html -O /var/lib/nginx/html/index.html
V_VERSION=$(/etc/v2ray/v2ray --version |grep V |awk '{print $2}')
S_VERSION=$(/etc/shadowsocks/ssserver -V | grep shadowsocks | awk '{print $2}')
REBOOTDATE=$(date)

sed -i "s/V_VERSION/$V_VERSION/g" /var/lib/nginx/html/index.html
sed -i "s/S_VERSION/$S_VERSION/g" /var/lib/nginx/html/index.html
sed -i "s/REBOOTDATE/$REBOOTDATE/g" /var/lib/nginx/html/index.html

echo "The UUID is: $UUID, V_PATH is: $V_PATH"
echo "The password is: $PASSWORD, S_PATH is: $S_PATH"

# start nginx
nginx
# main
/usr/bin/supervisord -c /etc/supervisord.conf