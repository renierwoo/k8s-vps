FROM debian:stable-slim

COPY docker-entrypoint.sh /usr/local/bin/

RUN set -ex; \
    chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]