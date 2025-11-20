#!/bin/sh
# Convenience wrapper to run the smoke-test with sensible defaults.
# Strategy:
#   - If a compose service named "smoke-test" exists, run it via docker compose
#     (so it can reach other services by service name inside the network).
#   - Otherwise, run the local script directly (useful when compose service
#     isn't defined or when testing host-exposed ports/IPs).

# Defaults (can be overridden by environment variables)
REACHABILITY_ONLY=${REACHABILITY_ONLY:-1}
TIMEOUT_SECS=${TIMEOUT_SECS:-60}
ENDPOINTS=${ENDPOINTS:-}

echo "Running smoke-test (REACHABILITY_ONLY=${REACHABILITY_ONLY}, TIMEOUT_SECS=${TIMEOUT_SECS})"
[ -n "$ENDPOINTS" ] && echo "  Checking endpoints: $ENDPOINTS"

# Detect whether a compose service named 'smoke-test' exists
has_compose_smoke() {
  command -v docker >/dev/null 2>&1 || return 1
  docker compose config --services 2>/dev/null | grep -qx "smoke-test"
}

if has_compose_smoke; then
  if [ -n "$ENDPOINTS" ]; then
    docker compose run --rm \
      -e REACHABILITY_ONLY="$REACHABILITY_ONLY" \
      -e TIMEOUT_SECS="$TIMEOUT_SECS" \
      -e ENDPOINTS="$ENDPOINTS" \
      smoke-test
  else
    docker compose run --rm \
      -e REACHABILITY_ONLY="$REACHABILITY_ONLY" \
      -e TIMEOUT_SECS="$TIMEOUT_SECS" \
      smoke-test
  fi
  exit $?
fi

# Fallback: run local script directly
SCRIPT_PATH="$(dirname "$0")/smoke-test.sh"
if [ ! -x "$SCRIPT_PATH" ]; then
  chmod +x "$SCRIPT_PATH" 2>/dev/null || true
fi

REACHABILITY_ONLY="$REACHABILITY_ONLY" \
TIMEOUT_SECS="$TIMEOUT_SECS" \
ENDPOINTS="$ENDPOINTS" \
"$SCRIPT_PATH"

exit $?
