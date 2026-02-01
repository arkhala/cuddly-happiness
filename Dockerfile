FROM alpine:3.23

ARG VERSION=experimental-pr15


RUN apk add --no-cache ca-certificates curl && \
    curl -fsSL -o /usr/local/bin/conduit "https://github.com/ssmirr/conduit/releases/download/${VERSION}/conduit-linux-amd64" && \
    chmod +x /usr/local/bin/conduit && \
    apk del curl
ENTRYPOINT ["/bin/sh", "-c", "exec conduit start -b \"${BANDWIDTH:-40}\" -m \"${MAXCLIENTS:-50}\" ${METRICSADDRESS:+--metrics-addr \"${METRICSADDRESS}\"}"]
