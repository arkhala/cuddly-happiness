FROM alpine:3.23

ARG VERSION=release-cli-2.0.0

RUN apk add --no-cache ca-certificates curl openssh && \
    curl -fsSL -o /usr/local/bin/conduit "https://github.com/Psiphon-Inc/conduit/releases/download/${VERSION}/conduit-linux-amd64" && \
    chmod +x /usr/local/bin/conduit

# === Minimal SSH Server Setup ===
RUN ssh-keygen -A && \
    adduser -D -s /bin/sh conduitmon && \
    mkdir -p /home/conduitmon/.ssh && \
    chmod 700 /home/conduitmon/.ssh && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config

# === Auto Join with Random Name ===
RUN echo '#!/bin/sh' > /usr/local/bin/auto-join && \
    echo 'if [ -n "$DASHBOARD_DOMAIN" ] && [ -n "$JOIN_TOKEN" ]; then' >> /usr/local/bin/auto-join && \
    echo '  if [ -z "$RELAY_NAME" ]; then' >> /usr/local/bin/auto-join && \
    echo '    RELAY_NAME="relay-$(head /dev/urandom | tr -dc a-z0-9 | head -c 6)"' >> /usr/local/bin/auto-join && \
    echo '  fi' >> /usr/local/bin/auto-join && \
    echo '  curl -sL "https://$DASHBOARD_DOMAIN/join/$JOIN_TOKEN" \' >> /usr/local/bin/auto-join && \
    echo '    -H "Content-Type: application/json" \' >> /usr/local/bin/auto-join && \
    echo '    -d "{\"name\":\"$RELAY_NAME\"}" | sh' >> /usr/local/bin/auto-join && \
    echo 'fi' >> /usr/local/bin/auto-join && \
    chmod +x /usr/local/bin/auto-join

ENV DASHBOARD_DOMAIN=""
ENV JOIN_TOKEN=""

# Start SSH + run auto-join + start conduit
ENTRYPOINT ["/bin/sh", "-c", "/usr/sbin/sshd && /usr/local/bin/auto-join && exec conduit start -b \"${BANDWIDTH:-40}\" -m \"${MAXCLIENTS:-50}\" ${METRICSADDRESS:+--metrics-addr \"${METRICSADDRESS}\"} ${SET:+${SET}}"]
