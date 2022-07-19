FROM docker.io/library/alpine:3.16.1

RUN echo "http://dl-3.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories
RUN apk upgrade
RUN apk add --update perl perl-lockfile-simple perl-dbi perl-dbd-pg perl-dbd-mysql fetchmail
RUN mkdir --parents /run/fetchmail

COPY --chown=fetchmail:fetchmail fetchmail.pl /usr/local/bin/fetchmail.pl

USER fetchmail

ENTRYPOINT [ "/usr/bin/perl" ]
CMD [ "/usr/local/bin/fetchmail.pl" ]