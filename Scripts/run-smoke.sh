#!/bin/sh
# Convenience wrapper to run the smoke-test with sensible defaults.
# Makes it easy to run the permissive reachability check without typing a long
# docker compose command.

# Defaults (can be overridden by environment variables)
REACHABILITY_ONLY=${REACHABILITY_ONLY:-1}
TIMEOUT_SECS=${TIMEOUT_SECS:-60}
ENDPOINTS=${ENDPOINTS:-}

echo "Running smoke-test (REACHABILITY_ONLY=${REACHABILITY_ONLY}, TIMEOUT_SECS=${TIMEOUT_SECS})"
if [ -n "$ENDPOINTS" ]; then
  echo "  Checking endpoints: $ENDPOINTS"
  docker compose run --rm -e REACHABILITY_ONLY="$REACHABILITY_ONLY" -e TIMEOUT_SECS="$TIMEOUT_SECS" -e ENDPOINTS="$ENDPOINTS" smoke-test
else
  docker compose run --rm -e REACHABILITY_ONLY="$REACHABILITY_ONLY" -e TIMEOUT_SECS="$TIMEOUT_SECS" smoke-test
fi

exit $?
