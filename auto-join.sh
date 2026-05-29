#!/bin/sh
if [ -n "$DASHBOARD_DOMAIN" ] && [ -n "$JOIN_TOKEN" ]; then
  if [ -z "$RELAY_NAME" ]; then
    RELAY_NAME="relay-$(head /dev/urandom | tr -dc a-z0-9 | head -c 6)"
  fi
  curl -sL "https://$DASHBOARD_DOMAIN/join/$JOIN_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"$RELAY_NAME\"}" | sh
fi
