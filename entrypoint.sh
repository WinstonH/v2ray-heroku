#!/bin/sh
sed -i "s/UUID/$UUID/g" /etc/v2ray/config.json
v2ray -config=/etc/v2ray/config.json

