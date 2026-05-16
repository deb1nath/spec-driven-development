---
name: cicd-pipeline
description: >
  Protocol for triggering CI/CD pipelines, monitoring their status, deploying
  to staging, and running health checks. Use during the GitOps phase.
---

## CI/CD Pipeline Protocol

### Trigger CI
CI triggers automatically when you push a branch to GitHub:
```bash
git push -u origin feature/{branch-name}
```

### Monitor Pipeline
```bash
# Polls every 30 seconds, exits non-zero if CI fails
gh run watch --exit-status
```
If CI fails, capture the failure details:
```bash
gh run view --log-failed
```
Include the captured log in docs/reports/{feature-id}/deploy-log.md.

### Deploy to Staging
```bash
./scripts/deploy.sh staging
```
If the deploy script does not exist, document exactly what manual steps would
be required and mark the deployment as MANUAL REQUIRED in the deploy log.

### Health Check
```bash
# Allow 30 seconds for deployment to stabilize
sleep 30
./scripts/health-check.sh staging
```
The health check must return exit code 0 (HTTP 200 from the health endpoint).
If it returns non-zero, record the failure and do NOT proceed to E2E testing.

### Deploy Report Fields
Document in docs/reports/{feature-id}/deploy-log.md:
- Branch name and commit SHA
- PR number and URL
- CI run ID and status (PASS/FAIL)
- CI duration
- Deployment target (always staging, never production)
- Deployed version or image tag
- Deployment timestamp (ISO 8601)
- Health check URL and response code
- Overall verdict: PASS / FAIL
