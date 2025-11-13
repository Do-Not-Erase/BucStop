## Sad Path Rollback

This document outlines the rollback strategy when an automatic deployment fails its smoke tests.

### Goal
Provide a deterministic way to revert the running stack to the last known-good commit (or a specified commit) after a failed deployment attempt.

### Components (Simplified)
1. `deployment-success.log` — one commit SHA per line. Last line = last good deployment.
2. `Scripts/rollback.sh` — minimal script: checkout last good commit, rebuild images, restart stack

### How Rollback Works (Simplified)
1. Read last line of `deployment-success.log` to get SHA.
2. `git checkout <SHA>` (detached HEAD).
3. `docker compose build` then `docker compose down` and `docker compose up -d --build`.
4. Done. (Repository stays detached until you `git checkout main`.)

### Recording Successful Deployments
After a successful deployment and smoke test pass, append the current commit SHA:

```bash
echo "$(git rev-parse HEAD)" >> deployment-success.log
```

On Windows (Git Bash / WSL): same command works. If only PowerShell is available:
```powershell
echo $(git rev-parse HEAD) >> deployment-success.log
```

Commit the updated file so future rollbacks know which commits were good:
```bash
git add deployment-success.log
git commit -m "Record successful deployment $(tail -n 1 deployment-success.log)"
git push
```

### Usage Example

```bash
./Scripts/rollback.sh
```

### Integrating With GitHub Actions
In the deployment workflow, on failure after smoke test, add a rollback step:
```yaml
      - name: Rollback (sad path)
        if: failure()
        run: |
          chmod +x Scripts/rollback.sh
          ./Scripts/rollback.sh
```

Ensure `deployment-success.log` is present and maintained.

### Notes & Future Improvements
- Add timestamps/environments to `deployment-success.log` if needed later.
- Optionally tag images (`docker tag ...`) for faster reverts.
- Run the smoke test again after rollback to confirm stability.
- Save failed deployment logs before rollback for debugging (optional).

### Safety Considerations
- Detached HEAD: remember to `git checkout main` when done.
- Schema changes may not be reversible; keep migrations backward-compatible in a simple setup.

### Troubleshooting
- If checkout fails: ensure the commit exists locally (`git fetch --all`).
- If build fails: inspect Docker build output; the previous commit may not be compatible.
- If containers start but app misbehave: verify the recorded commit is truly stable or consider using annotated tags.
