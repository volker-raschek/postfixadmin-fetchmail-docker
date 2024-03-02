FROM docker.io/library/alpine:3.18.5

# The file /etc/apk/repositories contains a list of the apk repositories. By
# default contains this file a list of the stable repositories pointing to the
# alpine version.
#
# Some perl packages are not part of the stable repositories. For this reason
# are the repositories switched to edge to access directly the latest versions
# of this apk packages.
#
# Using stable and edge at the same time is not allowed. For more information,
# take a look into the documentation of the edge repository.
#
#   https://wiki.alpinelinux.org/wiki/Repositories#Edge
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# Install packages
RUN apk upgrade && \
    apk add --update perl perl-lockfile-simple perl-dbi perl-dbd-pg perl-dbd-mysql fetchmail

RUN mkdir --parents /run/fetchmail

COPY --chown=fetchmail:fetchmail fetchmail.pl /usr/local/bin/fetchmail.pl

USER fetchmail

CMD [ "/usr/local/bin/fetchmail.pl" ]