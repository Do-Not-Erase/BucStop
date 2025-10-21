#### Note - this document was generated using GPT-5 mini in VS Code Copilot. It has been double-checked and verified for any hallucinations, and it was made with intentions to be built on at a later date.

# Empty Container (Test) — BucStop

This document explains the minimal "empty" test container added to the BucStop repository to help team members learn Docker workflows and test adding new microservices.

## What I added

- `Team-3-BucStop_Test/EmptyService/Dockerfile`
  - Based on `nginx:alpine`, serves a tiny `index.html` for verification.
- `Team-3-BucStop_Test/EmptyService/index.html`
  - A simple static HTML page that verifies the container runs correctly.
- Updated `docker-compose.yml` (root) with service `empty-service-test`
  - The service is attached to the existing `bucstop-network` and does not map any host ports by default (to avoid conflicts).

## Why this pattern

The project uses per-service build contexts and multi-stage .NET Dockerfiles for the game microservices. For a simple test container, using an existing lightweight base image like `nginx:alpine` is quick and safe.

Keeping the test service off the host network by default prevents accidental port collisions with existing services. When a developer wants to test access from their host machine, they can map a port locally.

## How to build and run locally

Prerequisites:
- Docker Desktop (Windows)
- From PowerShell or a Unix shell (WSL), in the repository root

Build (optional — `docker-compose up` will build automatically):

```powershell
# From repo root
docker-compose build empty-service-test
```

Run with docker-compose (no host port mapped):

```powershell
docker-compose up empty-service-test
```

Run and map a host port (e.g., map port 8085 to the container's 80):

```powershell
docker-compose up -d --build empty-service-test
# Map port manually if you prefer using docker run
docker run --rm -p 8085:80 --name empty-service-test_local imagename
```

Quick way to test by mapping port via an override (recommended):

1. Create a file named `docker-compose.override.yml` next to `docker-compose.yml` containing:

```yaml
services:
  empty-service-test:
    ports:
      - "8085:80"
```

2. Run `docker-compose up -d --build empty-service-test` and open http://localhost:8085

## Verification

- If you mapped a host port (8085), open http://localhost:8085 and you should see the "Empty Service Test Container" page.
- If no host port is mapped, you can exec into the API or use `docker-compose exec` from another container on the `bucstop-network` to curl the service at `http://empty-service-test`.

Example (exec into API gateway container):

```powershell
# Run this while docker-compose is up with the related services
docker-compose exec api-gateway sh -c "apk add --no-cache curl >/dev/null 2>&1 || true; curl -sS http://empty-service-test/"
```

## Next steps / How to convert into a real microservice

- Replace the `Dockerfile` with a .NET multi-stage build following the pattern in `Team-3-BucStop_Tetris/Tetris/Dockerfile` and adjust `docker-compose.yml` to expose a port and set `environment` variables.
- Add `.dockerignore` to the service folder copying from other services to speed builds and avoid copying unnecessary files.
- Update CI and deployment scripts when you want the new service in production.

## Troubleshooting

- Image build failures: ensure Docker Desktop is running and you have network access for base images.
- Port conflicts: map a different host port or avoid mapping entirely.
- File permission issues (Linux): `nginx:alpine` should work out of the box; if using volumes, check permissions.