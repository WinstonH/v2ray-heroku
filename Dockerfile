FROM alpine:latest
ENV UUID bae4c69e-3fe3-45d4-aaae-43dc34855efc
ENV PASSWORD herosocks
ENV V_PATH v_path
ENV S_PATH s_path
ENV TZ 'Asia/Shanghai'

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
&& apk upgrade --no-cache \
&& apk --update --no-cache add tzdata supervisor ca-certificates nginx curl wget unzip openssl \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone \
&& rm -rf /var/cache/apk/*
COPY install_v2ray.sh /tmp/install_v2ray.sh

ADD etc /etc

RUN cd /tmp \
# Install ss
&& ss_version=$(wget -O - https://api.github.com/repos/shadowsocks/shadowsocks-rust/releases/latest | sed 's/,/\n/g' | grep tag_name | awk  -F '"' '{print $4}') \
&& wget https://github.com/shadowsocks/shadowsocks-rust/releases/download/$ss_version/shadowsocks-$ss_version.x86_64-unknown-linux-musl.tar.xz \
&& tar xvJf shadowsocks-$ss_version.x86_64-unknown-linux-musl.tar.xz \
&& mv ss* /etc/shadowsocks/ \
# Install v2ray
&& /tmp/install_v2ray.sh \
&& mkdir /var/log/v2ray/  \
# Install v2ray-plugin for ss
&& plugin_version=$(wget -O - https://api.github.com/repos/shadowsocks/v2ray-plugin/releases/latest | sed 's/,/\n/g' | grep tag_name | awk  -F '"' '{print $4}') \
&& wget https://github.com/shadowsocks/v2ray-plugin/releases/download/$plugin_version/v2ray-plugin-linux-amd64-$plugin_version.tar.gz \
&& tar -xzvf v2ray-plugin-linux-amd64-*.tar.gz \
&& mv v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin \
&& rm -rf /tmp/* \
# Config env for heroku
&& adduser -D myuser \
&& mkdir -p /var/tmp/nginx/client_body

COPY entrypoint.sh /usr/bin/entrypoint.sh

USER myuser
CMD entrypoint.sh
