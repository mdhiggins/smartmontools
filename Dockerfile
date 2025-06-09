FROM alpine:latest
LABEL maintainer="mdhiggins <mdhiggins23@gmail.com>"

ENV TZ=America/New_York

RUN set -xe && \
    apk add --update --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    bash \
    tzdata \
    smartmontools \
    msmtp \
    mailutils && \
    rm -rf /tmp/* /var/tmp/ /var/cache/apk/*

ADD smartd.conf /etc/smartd.conf
ADD msmtprc /etc/msmtprc
ADD entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
RUN ln -sf /usr/bin/msmtp /usr/sbin/sendmail

ENTRYPOINT ["/entrypoint.sh"]
