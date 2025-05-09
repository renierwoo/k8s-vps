FROM debian:stable-slim

RUN set -ex; \
    apt-get --quiet=2 --assume-yes update

RUN set -ex; \
    apt-get --quiet=2 --assume-yes upgrade

COPY docker-entrypoint.sh /usr/local/bin/

RUN set -ex; \
    chmod +x /usr/local/bin/docker-entrypoint.sh

USER root

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]