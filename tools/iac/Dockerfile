FROM debian:stable-slim

RUN set -ex; \
    apt-get --quiet=2 --assume-yes update && \
    apt-get --quiet=2 --assume-yes upgrade && \
    rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin/

RUN set -ex; \
    chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]