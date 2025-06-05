FROM alpine:latest
LABEL maintainer="mdhiggins <mdhiggins23@gmail.com>"

ENV TZ=America/New_York

RUN set -xe && \
    apk add --update --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    bash \
    tzdata \
    smartmontools \
    ssmtp \
    mailutils && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    rm -rf /tmp/* /var/tmp/ /var/cache/apk/*

ADD smartd.conf /etc/smartd.conf
ADD ssmtp.conf /etc/ssmtp/ssmtp.conf
ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
