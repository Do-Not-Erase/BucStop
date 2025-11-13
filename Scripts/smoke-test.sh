#!/bin/sh
# Simple smoke test that waits for services and curls endpoints.
#
# Features added:
# - TIMEOUT_SECS and SLEEP_INTERVAL are configurable via environment variables.
# - ENDPOINTS can be provided via env (falls back to defaults).
# - REACHABILITY_ONLY=1 treats any HTTP response (including 4xx) as success and
#   therefore checks TCP/HTTP reachability rather than HTTP 2xx semantics.
# - On failure the script prints a short curl diagnostic to help debugging.

set -u

# Configuration (can be overridden via environment variables)
TIMEOUT_SECS="${TIMEOUT_SECS:-60}"
SLEEP_INTERVAL="${SLEEP_INTERVAL:-3}"

# Default list of endpoints to check (container service names + port). You can
# override by setting ENDPOINTS in the environment, e.g.:
# ENDPOINTS="http://api-gateway:80/Gateway http://bucstop:80"
ENDPOINTS="${ENDPOINTS:-http://bucstop:80 http://api-gateway:80 http://snake:80 http://pong:80 http://tetris:80}"

# When set to 1, any HTTP response (including 4xx/5xx) is considered a success as
# long as the TCP connection and HTTP exchange succeeded. Default: 0
REACHABILITY_ONLY="${REACHABILITY_ONLY:-0}"

check_url() {
  url=$1
  echo "Checking $url"
  elapsed=0
  while [ $elapsed -lt "$TIMEOUT_SECS" ]; do
    if [ "$REACHABILITY_ONLY" = "1" ]; then
      # Do not fail on HTTP status codes; only fail on network errors/timeouts.
      http_code=$(curl -sS --max-time 5 -o /dev/null -w "%{http_code}" "$url" 2>/dev/null) || rc=$?
      rc=${rc:-0}
      if [ $rc -eq 0 ]; then
        echo "  OK (reachable, HTTP ${http_code}): $url"
        return 0
      fi
      # If curl failed (rc != 0) we will fall through to diagnostic + retry
    else
      # Strict mode: require successful HTTP (2xx/3xx). curl -f will exit non-zero
      # on 4xx/5xx which we treat as not-ready.
      if curl -sSf --max-time 5 "$url" >/dev/null 2>&1; then
        echo "  OK: $url"
        return 0
      fi
    fi

    # Diagnostic output for why the check failed (short, helps debugging in CI logs)
    echo "  curl diagnostic for $url (showing error / response):"
    curl -v --max-time 5 "$url" || true

    echo "  Waiting for $url... (elapsed ${elapsed}s)"
    sleep "$SLEEP_INTERVAL"
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
