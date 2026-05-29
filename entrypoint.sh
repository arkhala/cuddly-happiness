#!/bin/sh

# Start SSH
/usr/sbin/sshd

# Auto-join if configured
if [ -n "$DASHBOARD_DOMAIN" ] && [ -n "$JOIN_TOKEN" ]; then
  if [ -z "$RELAY_NAME" ]; then
    RELAY_NAME="relay-$(head /dev/urandom | tr -dc a-z0-9 | head -c 6)"
  fi
  curl -sL "https://$DASHBOARD_DOMAIN/join/$JOIN_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"$RELAY_NAME\"}" | sh
fi

# Start conduit
exec conduit start \
  --data-dir "${DATA_DIR:-/data}" \
  -b "${BANDWIDTH:-40}" \
  -m "${MAXCLIENTS:-50}" \
  ${METRICSADDRESS:+--metrics-addr "${METRICSADDRESS}"} \
  ${SET:+${SET}}
