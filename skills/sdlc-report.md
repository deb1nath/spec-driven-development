---
name: sdlc-report
description: >
  Protocol for generating the final Supervisor SDLC report that summarizes
  all pipeline phases and makes a ship/no-ship recommendation.
---

## Final Report Protocol

### Report Structure
Write to `docs/reports/{feature-id}/final-report.md`:

```markdown
# SDLC Report: {Feature ID} — {Feature Title}
## Date: {ISO 8601}
## Status: PASS | FAIL | PARTIAL

## Executive Summary
{2-3 sentence summary of what was built and whether it meets requirements}

## Phase Results
| Phase | Agent | Status | Duration | Retries | Notes |
|-------|-------|--------|----------|---------|-------|
| 1. BA | business-analyst | PASS | 2m | 0 | |
| 2. Tests (Red) | test-writer | PASS | 5m | 0 | |
| 3. Implementation | developer | PASS | 12m | 1 | |
| 4. Tests (Green) | test-runner | PASS | 1m | 0 | |
| 5. GitOps | gitops | PASS | 4m | 0 | |
| 6. E2E | integration-tester | PASS | 3m | 0 | |

## Acceptance Criteria Verification
| AC ID | Description | Unit Test | E2E Test | API Test | Verdict |
|-------|-------------|-----------|----------|----------|---------|
| AC-1 | ... | PASS | PASS | N/A | PASS |

## Metrics
- Total pipeline duration: {time}
- Lines of code added: {N}
- Lines of test code added: {N}
- Test coverage: {N}% line / {N}% branch
- CI pipeline status: PASS

## Risk Assessment
- {any caveats, partial implementations, or known limitations}

## Recommendation
{SHIP / REWORK / NEEDS_DISCUSSION}
{If not SHIP, explain exactly what needs to change}
```

### Status Definitions
- **PASS**: All acceptance criteria verified by tests. All phases succeeded.
- **PARTIAL**: Some ACs verified, others not (E2E gap or test coverage gap). Ship with caveats.
- **FAIL**: One or more critical ACs failed. Do not ship.

### Recommendation Definitions
- **SHIP**: Status is PASS. All risks are acceptable.
- **REWORK**: Specific ACs failed. List exactly which ones and why.
- **NEEDS_DISCUSSION**: Ambiguous results requiring human judgment.
