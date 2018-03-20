FROM alpine:latest
ENV UUID bae4c69e-3fe3-45d4-aaae-43dc34855efc

ADD https://storage.googleapis.com/v2ray-docker/v2ray /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/v2ctl /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/geoip.dat /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/geosite.dat /usr/bin/v2ray/

COPY config.json /etc/v2ray/config.json
COPY entrypoint.sh /usr/bin/

RUN set -ex && \
    apk --no-cache add ca-certificates nginx && \
    mkdir /var/log/v2ray/ && \
    chmod +x /usr/bin/v2ray/v2ctl && \
    chmod +x /usr/bin/v2ray/v2ray
ENV PATH /usr/bin/v2ray:$PATH
COPY default.conf /etc/nginx/conf.d/default.conf
RUN adduser -D myuser && \
    mkdir /run/nginx
USER myuser
CMD entrypoint.sh
