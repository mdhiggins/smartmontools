FROM alphine:3.8
MAINTAINER mdhiggins <mdhiggins23@gmail.com>

RUN set -xe && \
    apk add --update --no-cache \
    smartmontools \
    ssmtp \
    mailutils && \
    rm -rf /tmp/* /var/tmp/

ADD smartd.conf /etc/smartd.conf
ADD ssmtp.conf /etc/ssmtp/ssmtp.conf

CMD /usr/sbin/smartd --debug
