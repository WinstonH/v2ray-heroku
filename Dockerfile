FROM alpine:latest
ENV UUID bae4c69e-3fe3-45d4-aaae-43dc34855efc
ENV WALLET default_wallet_address
ENV TZ 'Asia/Shanghai'

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
&& apk upgrade --no-cache \
&& apk --update --no-cache add tzdata supervisor ca-certificates nginx build-base cmake git curl wget unzip openssl-dev libmicrohttpd-dev hwloc-dev \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo "Asia/Shanghai" > /etc/timezone \
&& git clone https://github.com/fireice-uk/xmr-stak.git \
&& mkdir xmr-stak/build \
&& cd xmr-stak/build \
&& cmake -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF .. \
&& make install \
&& apk del --purge build-base cmake git \
&& rm -rf /var/cache/apk/*

ADD *.txt /xmr-stak/build/bin/ 

RUN VER=$(curl -s https://api.github.com/repos/v2ray/v2ray-core/releases/latest | grep tag_name | awk  -F '"' '{print $4}') \
&& wget https://github.com/v2ray/v2ray-core/releases/download/$VER/v2ray-linux-64.zip \
&& unzip v2ray-linux-64.zip \
&& cd v2ray-$VER-linux-64 \
&& mkdir -p /usr/bin/v2ray/ \
&& mv v2ray /usr/bin/v2ray/ \
&& mv v2ctl /usr/bin/v2ray/ \
&& mv *.dat /usr/bin/v2ray/ \
&& cd .. \
&& rm -rf v2ray-$VER-linux-64 v2ray-linux-64.zip

ENV PATH /usr/bin/v2ray:$PATH
COPY default.conf /etc/nginx/conf.d/default.conf
COPY supervisord.conf /etc/supervisord.conf
COPY config.json /etc/v2ray/config.json
COPY entrypoint.sh /usr/bin/

RUN mkdir /var/log/v2ray/  \
&& adduser -D myuser \
&& mkdir /run/nginx

USER myuser
CMD entrypoint.sh
