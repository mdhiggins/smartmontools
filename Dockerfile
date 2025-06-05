FROM lscr.io/linuxserver/baseimage-alpine:3.21
LABEL maintainer="mdhiggins <mdhiggins23@gmail.com>"

RUN set -xe && \
    apk add --update --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    smartmontools \
    ssmtp \
    mailutils && \
    rm -rf /tmp/* /var/tmp/

ADD smartd.conf /etc/smartd.conf
ADD ssmtp.conf /etc/ssmtp/ssmtp.conf

CMD /usr/sbin/smartd --debug
