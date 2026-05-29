#!/bin/sh

if [ -n "$DASHBOARD_DOMAIN" ] && [ -n "$JOIN_TOKEN" ]; then
  if [ -z "$RELAY_NAME" ]; then
    RELAY_NAME="relay-$(head /dev/urandom | tr -dc a-z0-9 | head -c 6)"
  fi

  echo "[Auto-Join] Joining dashboard as $RELAY_NAME..."

  # Ensure .ssh directory exists with correct permissions
  mkdir -p /home/conduitmon/.ssh
  chmod 700 /home/conduitmon/.ssh
  chown conduitmon:conduitmon /home/conduitmon/.ssh

  # Get the dashboard's public key and add it
  curl -sL "https://$DASHBOARD_DOMAIN/join/$JOIN_TOKEN?name=$RELAY_NAME" \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"$RELAY_NAME\"}" | sh

  echo "[Auto-Join] Done."
fi
