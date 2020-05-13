FROM haproxy:alpine

ENV LISTEN=":443 v4v6" \
    PRE_RESOLVE=0 \
    TALK="talk:80" \
    TIMEOUT_CLIENT=300s \
    TIMEOUT_CLIENT_FIN=30s \
    TIMEOUT_CONNECT=10s \
    TIMEOUT_SERVER=300s \
    TIMEOUT_SERVER_FIN=30s \
    TIMEOUT_TUNNEL=300s \
    VERBOSE=0

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.vendor=captnbp \
      org.label-schema.license=Apache-2.0 \
      org.label-schema.vcs-url="https://github.com/captnbp/docker-tcp-proxy"

RUN apk add --no-cache dumb-init

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg

# Runs "/usr/bin/dumb-init -- /my/script --with --args"
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
