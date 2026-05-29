FROM alpine:3.23

ARG VERSION=release-cli-2.0.0

RUN apk add --no-cache ca-certificates curl openssh && \
    curl -fsSL -o /usr/local/bin/conduit "https://github.com/Psiphon-Inc/conduit/releases/download/${VERSION}/conduit-linux-amd64" && \
    chmod +x /usr/local/bin/conduit

# Copy and set up auto-join script
COPY auto-join.sh /usr/local/bin/auto-join
RUN chmod +x /usr/local/bin/auto-join

# === Minimal SSH Server Setup ===
RUN ssh-keygen -A && \
    adduser -D -s /bin/sh conduitmon && \
    mkdir -p /home/conduitmon/.ssh && \
    chmod 700 /home/conduitmon/.ssh && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config

ENV DASHBOARD_DOMAIN=""
ENV JOIN_TOKEN=""

# Start SSH + run auto-join + start conduit
ENTRYPOINT ["/bin/sh", "-c", "/usr/sbin/sshd && /usr/local/bin/auto-join && exec conduit start -b \"${BANDWIDTH:-40}\" -m \"${MAXCLIENTS:-50}\" ${METRICSADDRESS:+--metrics-addr \"${METRICSADDRESS}\"} ${SET:+${SET}}"]
#ENTRYPOINT ["/bin/sh", "-c", "/usr/sbin/sshd && exec conduit start -b 40 -m 50"]
#ENTRYPOINT ["/entrypoint.sh"]
#COPY entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh
#ENTRYPOINT ["/entrypoint.sh"]
