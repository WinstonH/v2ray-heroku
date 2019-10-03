FROM alpine:edge
ENV UUID bae4c69e-3fe3-45d4-aaae-43dc34855efc
ENV TZ 'Asia/Shanghai'

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
&& apk upgrade --no-cache \
&& apk --update --no-cache add tzdata supervisor ca-certificates nginx unzip \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone \
&& rm -rf /var/cache/apk/*

RUN mkdir -p /usr/bin/v2ray/ \
&& cd /usr/bin/v2ray/ \
&& VER=$(wget -O - https://api.github.com/repos/v2ray/v2ray-core/releases/latest | grep tag_name | awk  -F '"' '{print $4}') \
&& wget -O v2ray-linux-64.zip https://github.com/v2ray/v2ray-core/releases/download/$VER/v2ray-linux-64.zip \
&& unzip v2ray-linux-64.zip \
&& chmod +x v2ray v2ctl \
&& rm -rf v2ray-linux-64.zip \
&& mkdir /var/log/v2ray/  \
&& adduser -D myuser \
&& mkdir /run/nginx

ENV PATH /usr/bin/v2ray:$PATH
COPY default.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisord.conf
COPY config.json /etc/v2ray/config.json
COPY entrypoint.sh /entrypoint.sh
COPY index.html /var/lib/nginx/html/index.html

USER myuser
CMD ["/entrypoint.sh"]
