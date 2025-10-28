#!/bin/sh
# Simple smoke test that waits for services and curls endpoints.
# Exits 0 if all endpoints respond (HTTP 2xx/3xx/200-399), non-zero otherwise.

set -u

# Configuration
TIMEOUT_SECS=60 # Max time to wait for each endpoint
SLEEP_INTERVAL=3 # Seconds between retries

# List of endpoints to check (container service names + port)
ENDPOINTS="http://bucstop:80 http://api-gateway:80 http://snake:80 http://pong:80 http://tetris:80"

check_url() {
  url=$1
  echo "Checking $url"
  elapsed=0
  while [ $elapsed -lt $TIMEOUT_SECS ]; do
    # -s: silent; -S: show errors; -f: fail on HTTP error codes
    if curl -sSf "$url" >/dev/null 2>&1; then
      echo "  OK: $url"
      return 0
    fi
    echo "  Waiting for $url... (elapsed ${elapsed}s)"
    sleep $SLEEP_INTERVAL
    elapsed=$((elapsed + SLEEP_INTERVAL))
  done
  echo "  TIMEOUT: $url did not respond within ${TIMEOUT_SECS}s"
  return 1
}

any_fail=0
for e in $ENDPOINTS; do
  if ! check_url "$e"; then
    any_fail=1
  fi
done

if [ $any_fail -eq 0 ]; then
  echo "SMOKE TESTS PASSED"
  exit 0
else
  echo "SMOKE TESTS FAILED"
  exit 2
fi
