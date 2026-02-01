FROM alpine:3.23

ARG VERSION=experimental-pr15

CMD ["/bin/sh"]

RUN apk add --no-cache ca-certificates curl 

RUN curl -fsSL -o /usr/local/bin/conduit https://github.com/ssmirr/conduit/releases/download/${VERSION}/conduit-linux-amd64 

RUN chmod +x /usr/local/bin/conduit 

RUN apk del curl

ENTRYPOINT ["/bin/sh", "-c", "exec conduit start -b \"${BANDWIDTH:-40}\" -m \"${MAXCLIENTS:-50}\" ${METRICSADDRESS:+--metrics-addr \"${METRICSADDRESS}\"}"]
