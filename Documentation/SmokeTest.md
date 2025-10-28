# Smoke Test (docker compose)

This document explains the lightweight smoke-test stage added to `docker-compose.yml`.

What I added

- `smoke-test` service in `docker-compose.yml` using the `curlimages/curl` image.
- `Scripts/smoke-test.sh` — a small shell script that retries curl requests to the services and returns success/failure.

Behavior

- The `smoke-test` service depends on the main services (`bucstop`, `api-gateway`, `snake`, `pong`, `tetris`) so Docker Compose starts them first.
- Because `depends_on` in compose does not wait for "readiness", the script performs retries for up to a timeout (default 60s), polling each endpoint until it responds or the timeout is reached.

How to run the smoke test

From the repository root run:

```powershell
# Start only smoke-test (Compose will start its dependencies)
docker compose up smoke-test
```

You can run detached but since smoke-test exits with a non-zero code on failure, running attached is useful to see the logs:

```powershell
docker compose up --build smoke-test
```

If you want to run the smoke-test repeatedly in CI, use:

```powershell
# Run and return the exit code from smoke-test
docker compose up --build --exit-code-from smoke-test smoke-test
```

Notes & customization

- Adjust `Scripts/smoke-test.sh` to change the TIMEOUT_SECS or add/remove endpoints.
-- If you prefer healthcheck-based readiness, add `healthcheck` blocks to each service in `docker-compose.yml` and change `depends_on` to wait for `service_healthy` (note: `service_healthy` behaviour depends on the compose file version).
- The script runs inside the `bucstop-network` and refers to services by their Compose service names (e.g., `bucstop`, `api-gateway`). Ensure those names match the `docker-compose.yml` services.

Troubleshooting

- If smoke-test fails because of DNS resolution, ensure the other services are starting in the same compose project and network.
- For extra debugging, run `docker compose logs smoke-test` or `docker compose logs <service>` to inspect startup logs.

Next steps

- Optionally add a CI job that runs `docker compose up --build --exit-code-from smoke-test smoke-test` and fails the pipeline on a non-zero exit code.
- Consider adding `healthcheck` blocks to services for more robust readiness checks.
