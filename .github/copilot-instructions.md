# Agentic SDLC — Copilot Instructions

This project uses an AI-powered SDLC pipeline orchestrated by a Supervisor agent fleet.
Full agent and skill definitions live in `agents/` and `skills/` — reference them via @workspace.

## Starting the Pipeline

To implement a feature, say:
> "Implement the feature spec at docs/specs/features/{FEAT-ID}.md using the supervisor agent"

The pipeline runs: BA → TDD (red) → Implement (green) → Test verify → GitOps → E2E

## Agent Fleet

| Agent | File | Role |
|---|---|---|
| supervisor | agents/supervisor.md | Orchestrates all phases, makes pass/fail decision |
| business-analyst | agents/business-analyst.md | Creates JIRA story + acceptance criteria |
| test-writer | agents/test-writer.md | Writes failing JUnit tests (TDD red phase) |
| developer | agents/developer.md | Implements code to pass tests (TDD green phase) |
| test-runner | agents/test-runner.md | Runs full test suite, reports coverage |
| gitops | agents/gitops.md | Git operations, CI/CD, staging deployment |
| integration-tester | agents/integration-tester.md | Playwright E2E + Postman API tests |
| reviewer | agents/reviewer.md | Code quality gate (optional, between Phase 4–5) |

## Skills

| Skill | File | Used by |
|---|---|---|
| create-jira-story | skills/create-jira-story.md | business-analyst |
| write-junit-tests | skills/write-junit-tests.md | test-writer |
| run-test-suite | skills/run-test-suite.md | test-runner, developer |
| implement-feature | skills/implement-feature.md | developer |
| git-workflow | skills/git-workflow.md | gitops |
| cicd-pipeline | skills/cicd-pipeline.md | gitops |
| e2e-test-browser | skills/e2e-test-browser.md | integration-tester |
| api-test-postman | skills/api-test-postman.md | integration-tester |
| sdlc-report | skills/sdlc-report.md | supervisor |

## Tech Stack Defaults

**Java 17 / Spring Boot 3.x / Gradle / JUnit 5 / Playwright / Newman**

To override: edit the `## Technology Stack` section in `CLAUDE.md`.
Each agent that runs build commands has a `<!-- TECH-STACK DEFAULTS -->` comment
block at the top of its file listing exactly what to change.

## Data Flow

```
docs/specs/features/{id}.md     ← you write this
docs/reports/{id}/ba-output.md  ← Phase 1 output
docs/reports/{id}/test-plan.md  ← Phase 2 output
docs/reports/{id}/implementation-log.md ← Phase 3 output
docs/reports/{id}/test-results.md       ← Phase 4 output
docs/reports/{id}/deploy-log.md         ← Phase 5 output
docs/reports/{id}/e2e-results.md        ← Phase 6 output
docs/reports/{id}/final-report.md       ← Supervisor verdict
```

## Human Gates

The Supervisor pauses and asks for your approval at two points:
1. **Gate 1** — After acceptance criteria are written (before tests are written)
2. **Gate 2** — After all tests pass (before deployment)
