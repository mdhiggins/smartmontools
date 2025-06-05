FROM alpine:latest
LABEL maintainer="mdhiggins <mdhiggins23@gmail.com>"

ENV TZ=America/New_York

RUN set -xe && \
    apk add --update --no-cache \
    tzdata \
    smartmontools \
    ssmtp \
    heirloom-mailx && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    rm -rf /tmp/* /var/tmp/ /var/cache/apk/*

ADD smartd.conf /etc/smartd.conf
ADD ssmtp.conf /etc/ssmtp/ssmtp.conf

CMD /usr/sbin/smartd --debug
