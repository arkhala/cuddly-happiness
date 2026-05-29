#!/bin/sh

# Start SSH server
/usr/sbin/sshd

# Run auto-join (if configured)
/usr/local/bin/auto-join

# Start conduit
exec conduit start \
  --data-dir "${DATA_DIR:-/data}" \
  -b "${BANDWIDTH:-40}" \
  -m "${MAXCLIENTS:-50}" \
  ${METRICSADDRESS:+--metrics-addr "${METRICSADDRESS}"} \
  ${SET:+${SET}}
