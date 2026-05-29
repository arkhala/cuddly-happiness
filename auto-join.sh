#!/bin/sh

if [ -n "$DASHBOARD_DOMAIN" ] && [ -n "$JOIN_TOKEN" ]; then
  echo "[Auto-Join] Setting up SSH access..."

  # Create .ssh directory with correct permissions
  mkdir -p /home/conduitmon/.ssh
  chmod 700 /home/conduitmon/.ssh
  chown conduitmon:conduitmon /home/conduitmon/.ssh

  # Create authorized_keys file
  touch /home/conduitmon/.ssh/authorized_keys
  chmod 600 /home/conduitmon/.ssh/authorized_keys
  chown conduitmon:conduitmon /home/conduitmon/.ssh/authorized_keys

  echo "[Auto-Join] Joining dashboard..."

  # Join (dashboard will auto-assign unique name)
  curl -sL "https://$DASHBOARD_DOMAIN/join/$JOIN_TOKEN?port=2222" | sh

  echo "[Auto-Join] Done."
fi
