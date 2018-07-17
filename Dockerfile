FROM debian:jessie
MAINTAINER mdhiggins <mdhiggins23@gmail.com>

RUN apt-get update && \
    apt-get -qq install smartmontools ssmtp mailutils && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD smartd.conf /etc/smartd.conf

CMD /usr/sbin/smartd --debug
