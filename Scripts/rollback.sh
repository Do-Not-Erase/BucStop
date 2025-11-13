#!/bin/sh
# ------------------------------------------------------------
# rollback.sh
# Purpose: Restore the Docker stack to the last known good Git commit
#          recorded in deployment-success.log.
# Why:    Used automatically by the GitHub Actions workflow when the
#         post-deploy smoke test fails ("sad path" scenario).
# Assumes:
#   - File deployment-success.log exists in repo root (one SHA per line)
#   - Last line = most recent successful deployment commit
#   - Runner has git + docker + docker compose available
# Strategy:
#   1. Read last good commit SHA
#   2. git checkout that commit (detached HEAD)
#   3. Rebuild images (ensures compatibility with that commit)
#   4. Restart stack
# Caveat: After checkout you are in detached HEAD; to resume normal work
#         run: git checkout main   (or your branch)
# ------------------------------------------------------------

set -e

SUCCESS_FILE="deployment-success.log"  # log file tracking successful deployment commits

if [ ! -f "$SUCCESS_FILE" ]; then
  echo "rollback: $SUCCESS_FILE not found" >&2
  exit 1
fi

TARGET_COMMIT=$(tail -n 1 "$SUCCESS_FILE" | tr -d '\r')  # strip possible CR from Windows edits
if [ -z "$TARGET_COMMIT" ]; then
  echo "rollback: no commit found in $SUCCESS_FILE" >&2
  exit 2
fi

echo "rollback: reverting to commit $TARGET_COMMIT"
git fetch --quiet || true
git checkout "$TARGET_COMMIT"

echo "rollback: rebuilding images (ensures images match reverted code)"
docker compose build
echo "rollback: restarting stack (fresh start on reverted commit)"
docker compose down || true
docker compose up -d --build
echo "rollback: complete"

echo "NOTE: Detached HEAD at $TARGET_COMMIT. To return to main branch: git checkout main"