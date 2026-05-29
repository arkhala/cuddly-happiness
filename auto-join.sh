#!/bin/sh

if [ -n "$DASHBOARD_DOMAIN" ] && [ -n "$JOIN_TOKEN" ]; then
  echo "[Auto-Join] Joining dashboard..."

  # Ensure SSH directory exists with correct permissions
  mkdir -p /home/conduitmon/.ssh
  chmod 700 /home/conduitmon/.ssh
  chown conduitmon:conduitmon /home/conduitmon/.ssh

  # Join the dashboard (it will automatically assign a unique name)
  curl -sL "https://$DASHBOARD_DOMAIN/join/$JOIN_TOKEN" | sh

  echo "[Auto-Join] Done."
fi
