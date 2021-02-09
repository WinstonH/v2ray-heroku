FROM alpine:latest
ENV UUID bae4c69e-3fe3-45d4-aaae-43dc34855efc
ENV V_PATH v_path
ENV S_PATH s_path
ENV TZ 'Asia/Shanghai'

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
&& apk upgrade --no-cache \
&& apk --update --no-cache add tzdata supervisor ca-certificates nginx curl wget unzip openssl \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone \
&& rm -rf /var/cache/apk/*

RUN cd /tmp \
&& wget -qO- https://raw.githubusercontent.com/v2fly/docker/master/v2ray.sh | sh \
&& mkdir /var/log/v2ray/  \
&& adduser -D myuser \
&& mkdir /run/nginx \
&& mkdir -p /var/tmp/nginx/client_body

ADD etc /etc
COPY entrypoint.sh /usr/bin/

USER myuser
CMD entrypoint.sh
