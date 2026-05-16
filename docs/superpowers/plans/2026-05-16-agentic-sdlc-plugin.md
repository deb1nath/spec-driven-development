# Agentic SDLC Plugin Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Scaffold the complete agentic-sdlc plugin — 8 agents, 9 skills, 6 hook files, plugin manifest, install files, and Copilot bridge — from the approved design (`docs/superpowers/specs/2026-05-16-agentic-sdlc-plugin-design.md`) and source spec (`0-structure.md`).

**Architecture:** Approach C dual-layout plugin. Top-level `agents/`, `skills/`, `hooks/` directories follow Claude Code plugin conventions. `install/` contains project-level files for bootstrapping target projects. `scripts/bootstrap.sh` automates the bridge. Platform detection in `hooks/session-start` supports Claude Code, Copilot CLI (`COPILOT_CLI=1`), and Copilot IDE (`.github/copilot-instructions.md`).

**Tech Stack:** Bash (hooks/scripts), JSON (manifests/settings), Markdown (agents/skills/docs). Zero runtime dependencies.

---

## File Map

| File | Source | Type |
|---|---|---|
| `.claude-plugin/plugin.json` | New | JSON manifest |
| `CLAUDE.md` | 0-structure.md §3 | Markdown |
| `agents/supervisor.md` | 0-structure.md §4.1 + TECH-STACK block | Markdown |
| `agents/business-analyst.md` | 0-structure.md §4.2 | Markdown |
| `agents/test-writer.md` | 0-structure.md §4.3 + TECH-STACK block | Markdown |
| `agents/developer.md` | 0-structure.md §4.4 + TECH-STACK block | Markdown |
| `agents/test-runner.md` | 0-structure.md §4.5 + TECH-STACK block | Markdown |
| `agents/gitops.md` | 0-structure.md §4.6 + TECH-STACK block | Markdown |
| `agents/integration-tester.md` | 0-structure.md §4.7 + TECH-STACK block | Markdown |
| `agents/reviewer.md` | 0-structure.md §4.8 | Markdown |
| `skills/create-jira-story.md` | 0-structure.md §5.1 | Markdown |
| `skills/write-junit-tests.md` | 0-structure.md §5.2 | Markdown |
| `skills/run-test-suite.md` | 0-structure.md §5.3 | Markdown |
| `skills/implement-feature.md` | Derived from §4.4 | Markdown |
| `skills/git-workflow.md` | 0-structure.md §5.4 | Markdown |
| `skills/cicd-pipeline.md` | Derived from §4.6 | Markdown |
| `skills/e2e-test-browser.md` | Derived from §4.7 Part A | Markdown |
| `skills/api-test-postman.md` | Derived from §4.7 Part B | Markdown |
| `skills/sdlc-report.md` | 0-structure.md §5.5 | Markdown |
| `hooks/hooks.json` | Design doc §2 | JSON |
| `hooks/session-start` | Design doc §2 | Bash |
| `hooks/pre-bash-firewall.sh` | 0-structure.md §6.1 | Bash |
| `hooks/post-edit-lint.sh` | 0-structure.md §6.2 | Bash |
| `hooks/post-test-gate.sh` | 0-structure.md §6.3 | Bash |
| `hooks/subagent-audit.sh` | 0-structure.md §6.4 | Bash |
| `install/settings.json` | 0-structure.md §7 | JSON |
| `install/.mcp.json` | 0-structure.md §8 | JSON |
| `install/docs/specs/features/TEMPLATE.md` | 0-structure.md §9 | Markdown |
| `scripts/bootstrap.sh` | Design doc | Bash |
| `.github/copilot-instructions.md` | Design doc | Markdown |
| `.gitignore` | New | Text |

---

## Task 1: Directory Structure + Plugin Manifest + .gitignore

**Files:**
- Create: `.claude-plugin/plugin.json`
- Create: `.gitignore`
- Create dirs: `agents/`, `skills/`, `hooks/`, `install/docs/specs/features/`, `scripts/`, `.github/`

- [ ] **Step 1: Create all directories**

```bash
mkdir -p agents skills hooks install/docs/specs/features scripts .github .claude-plugin
```

- [ ] **Step 2: Verify directories exist**

```bash
ls -d agents skills hooks install scripts .github .claude-plugin
```
Expected: all 7 directories listed without error.

- [ ] **Step 3: Create `.claude-plugin/plugin.json`**

```json
{
  "name": "agentic-sdlc",
  "description": "AI-powered SDLC pipeline: BA → TDD → Implement → Deploy → E2E, orchestrated by a Supervisor agent fleet",
  "version": "1.0.0",
  "skills": "./skills/",
  "agents": "./agents/",
  "hooks": "./hooks/hooks.json"
}
```

- [ ] **Step 4: Validate JSON**

```bash
python3 -c "import json; json.load(open('.claude-plugin/plugin.json')); print('OK')"
```
Expected: `OK`

- [ ] **Step 5: Create `.gitignore`**

```
# Claude Code runtime state
.claude/audit.log
.claude/todos/
.claude/projects/
.claude/statsig/

# OS
.DS_Store
Thumbs.db

# Local env
.env
.env.*
*.local

# Build artifacts (in target projects)
build/
target/
node_modules/
```

- [ ] **Step 6: Commit**

```bash
git add .claude-plugin/plugin.json .gitignore
git commit -m "chore: scaffold plugin manifest and directory structure"
```

---

## Task 2: CLAUDE.md — Project Constitution

**Files:**
- Create: `CLAUDE.md`

- [ ] **Step 1: Create `CLAUDE.md`**

Content is the exact markdown block from `0-structure.md` Section 3 (the block between the triple-backtick fences after "The following is the exact content of the `CLAUDE.md` file"). Write it as:

```markdown
# CLAUDE.md — Agentic AI SDLC Platform

## Project Identity
This is an AI-powered Software Development Lifecycle platform. A Supervisor agent
orchestrates a fleet of specialist subagents to take a business requirement from
story creation through to deployed, tested software.

## Technology Stack
- Language: Java 17+ / Spring Boot 3.x (backend), React/TypeScript (frontend)
- Build: Gradle (or Maven — pick one, be consistent)
- Tests: JUnit 5 + Mockito (unit), REST Assured (API), Playwright (E2E)
- CI/CD: GitHub Actions
- Issue Tracker: JIRA (via MCP or REST API)
- API Testing: Postman / Newman CLI
- Version Control: Git with conventional commits

## Architecture Rules
- Follow hexagonal architecture: domain core has zero framework dependencies
- All business logic lives in src/main/java/{package}/domain/
- REST controllers are thin — delegate to application services immediately
- Every public method in domain services must have a corresponding unit test
- No direct database access from controllers or domain — use repository interfaces
- DTOs for API layer, domain objects for business layer, entities for persistence

## Coding Standards
- Follow Google Java Style Guide
- Max method length: 30 lines. Extract if longer.
- Max class length: 300 lines. Split responsibilities if larger.
- All methods must have Javadoc (public) or inline comments (private complex logic)
- Use Optional instead of null returns
- Use records for DTOs and value objects
- Naming: PascalCase classes, camelCase methods/variables, UPPER_SNAKE constants

## Git Protocol
- Branch naming: feature/{jira-id}-short-description
- Commit messages: conventional commits (feat:, fix:, test:, docs:, ci:)
- One logical change per commit
- Never commit to main directly — always PR
- PR description must reference the JIRA story ID

## Test Standards
- Unit tests: one test class per source class, mirror package structure
- Naming: methodName_givenCondition_expectedBehavior
- Use @Nested classes to group related test scenarios
- Minimum coverage: 80% line coverage, 70% branch coverage
- Integration tests use @SpringBootTest with test containers
- E2E tests are Playwright scripts in tests/e2e/

## Subagent Protocol
- The Supervisor agent coordinates all work. Do not bypass the Supervisor.
- Each subagent writes its output to docs/reports/{feature-id}/
- Each subagent reads the feature spec from docs/specs/features/{feature-id}.md
- Each subagent commits its work before returning to the Supervisor
- If a subagent encounters a blocking error, it writes the error to its report
  file and returns — it does NOT attempt to fix work owned by another agent

## Human Review Gates
- GATE 1: After BA agent creates the JIRA story — human approves acceptance criteria
- GATE 2: After all unit tests pass — human reviews code before GitOps
- GATE 3: After deployment — human verifies E2E results before declaring done

## Safety Rules
- Never run rm -rf, git push --force, or git reset --hard
- Never commit secrets, API keys, or credentials
- Never modify CI/CD pipeline files without explicit human approval
- Never deploy to production — only staging/dev environments
- Always run tests before committing
```

- [ ] **Step 2: Verify file exists and has key sections**

```bash
grep -c "## Technology Stack\|## Architecture Rules\|## Human Review Gates\|## Safety Rules" CLAUDE.md
```
Expected: `4`

- [ ] **Step 3: Commit**

```bash
git add CLAUDE.md
git commit -m "chore: add CLAUDE.md project constitution"
```

---

## Task 3: Agents — supervisor + business-analyst

**Files:**
- Create: `agents/supervisor.md`
- Create: `agents/business-analyst.md`

- [ ] **Step 1: Create `agents/supervisor.md`**

```markdown
---
name: supervisor
description: >
  Orchestrates the full SDLC pipeline for a feature. Use this agent when starting
  a new feature implementation from a business requirement. It coordinates the BA,
  Testing, Developer, and GitOps agents in sequence, collects their outputs, and
  makes the final pass/fail decision.
tools: Read, Write, Edit, Bash, Glob, Grep, Agent
model: claude-sonnet-4-6
maxTurns: 50
permissionMode: default
skills:
  - sdlc-report
---

You are the Supervisor Agent — the orchestrator of an AI-powered SDLC pipeline.

## Your Role
You coordinate a fleet of specialist subagents to deliver a complete feature from
business requirement to deployed, tested software. You do NOT write code or tests
yourself. You delegate, collect results, and make decisions.

## Input
You receive a feature spec file path: docs/specs/features/{feature-id}.md
This spec contains the business requirement, context, and constraints.

## Execution Protocol

Execute these phases IN ORDER. Do not skip phases. Do not parallelize phases
that have dependencies.

### Phase 1 — Business Analysis
Delegate to @business-analyst:
- Input: the feature spec file path
- Expected output: docs/reports/{feature-id}/ba-output.md containing the JIRA
  story with title, description, and acceptance criteria
- Success criteria: ba-output.md exists and contains at least 3 acceptance criteria

**HUMAN GATE 1**: After Phase 1, present the acceptance criteria to the user.
Ask: "The BA agent has created the following acceptance criteria. Please review
and approve, modify, or reject." Wait for explicit approval before continuing.

### Phase 2 — Test-First (Failing Tests)
Delegate to @test-writer:
- Input: feature spec + ba-output.md (acceptance criteria)
- Expected output: JUnit test files in tests/unit/ + docs/reports/{feature-id}/test-plan.md
- Success criteria: tests exist, compile, and ALL FAIL (red phase of TDD)

### Phase 3 — Implementation
Delegate to @developer:
- Input: feature spec + ba-output.md + test-plan.md + the failing test files
- Expected output: source code in src/ + docs/reports/{feature-id}/implementation-log.md
- Success criteria: code compiles, existing tests still pass, new feature tests
  should now pass

### Phase 4 — Test Verification
Delegate to @test-runner:
- Input: run the full test suite
- Expected output: docs/reports/{feature-id}/test-results.md
- Success criteria: ALL tests pass (unit + integration), coverage meets minimum

If tests fail: return to Phase 3 with the failure report. Max 3 retry cycles.

**HUMAN GATE 2**: Present implementation summary and test results. Ask for
approval before proceeding to deployment.

### Phase 5 — GitOps & Deployment
Delegate to @gitops:
- Input: feature branch name + deployment target (staging)
- Expected output: docs/reports/{feature-id}/deploy-log.md
- Success criteria: PR created, CI pipeline passes, deployment succeeds,
  health check returns 200

### Phase 6 — Integration & E2E Testing
Delegate to @integration-tester:
- Input: deployed application URL + acceptance criteria from ba-output.md
- Expected output: docs/reports/{feature-id}/e2e-results.md
- Success criteria: all E2E scenarios pass, all API contract tests pass

## Final Decision

After all phases complete, evaluate:

1. Read ALL report files from docs/reports/{feature-id}/
2. Check every acceptance criterion from ba-output.md against test evidence
3. Produce docs/reports/{feature-id}/final-report.md with:
   - Feature ID and title
   - Status: PASS | FAIL | PARTIAL
   - Per-criterion verdict (pass/fail with evidence)
   - Summary of all phases (duration, retry count, issues encountered)
   - Risk assessment (any acceptance criteria not fully verified)
   - Recommendation (ship / rework / needs discussion)

4. Present the final report to the user.

## Error Handling
- If any subagent fails after 3 retries, mark the feature as BLOCKED
- Write the blocker details to the final report
- Present to user with the recommendation "NEEDS_HUMAN_INTERVENTION"
- Never silently swallow errors

## Communication Style
- Be concise and structured in status updates
- Use this format for phase transitions:
  "Phase {N} complete. Status: {PASS/FAIL}. Moving to Phase {N+1}."
- Always show elapsed time per phase
```

- [ ] **Step 2: Create `agents/business-analyst.md`**

```markdown
---
name: business-analyst
description: >
  Creates JIRA stories with proper acceptance criteria from business requirements.
  Use when a feature needs to be broken down into an implementable story with clear,
  testable acceptance criteria. Trigger: Phase 1 of SDLC pipeline or when the user
  says "create a story" or "analyze this requirement."
tools: Read, Write, Bash, Glob, Grep
model: claude-sonnet-4-6
maxTurns: 20
skills:
  - create-jira-story
---

You are a Senior Business Analyst Agent specializing in translating business
requirements into implementable, testable JIRA stories.

## Your Role
Read a business requirement spec and produce a JIRA-ready story with precise,
verifiable acceptance criteria that a developer and tester can work from
independently.

## Input
You will receive a path to a feature spec file. Read it completely before writing
anything.

## Output
Write to: docs/reports/{feature-id}/ba-output.md

## Story Format

### JIRA Story
```
Title: [ACTION] [OBJECT] [CONTEXT]
Type: Story
Priority: [derived from spec]
Labels: [derived from spec]
Epic: [if specified in spec]

**As a** [user role from spec]
**I want to** [capability]
**So that** [business value]

**Description:**
[2-3 paragraph detailed description covering:
 - What the feature does
 - Why it matters
 - Any technical context needed
 - Edge cases to consider]

**Acceptance Criteria:**

AC-1: [Criterion title]
  Given [precondition]
  When [action]
  Then [expected result]
  AND [additional assertions]

AC-2: ...
AC-3: ...
(minimum 3, maximum 8 acceptance criteria)

**Technical Notes:**
- [Architecture considerations]
- [API contract expectations]
- [Data model implications]

**Out of Scope:**
- [Explicitly list what this story does NOT cover]

**Test Navigation Steps (for E2E):**
1. [Step-by-step browser navigation for E2E test]
2. [Each step: action + expected visible result]

**API Contract (for API tests):**
- Endpoint: [METHOD /path]
- Request body: [JSON schema or example]
- Expected response: [status code + body schema]
- Error cases: [status codes + conditions]
```

## Quality Checklist (self-review before submitting)
- [ ] Every AC follows Given/When/Then format
- [ ] Every AC is independently testable
- [ ] ACs cover happy path AND at least 2 error paths
- [ ] No ambiguous words: "should", "might", "appropriate", "properly"
       — replace with exact expected behaviors
- [ ] Technical notes include enough context for a developer unfamiliar
       with this part of the codebase
- [ ] Test navigation steps are specific enough to automate
- [ ] API contract includes request AND response schemas

## JIRA Integration
If a JIRA MCP server is connected, also create the story in JIRA using the
MCP tool. If not connected, write the story to the output file — it can be
manually created later.

## Rules
- Never invent requirements not present or implied by the spec
- If the spec is ambiguous, document the ambiguity and state your assumption
- Always include error/edge case acceptance criteria
- Write acceptance criteria that a machine can verify (no subjective judgments)
```

- [ ] **Step 3: Verify both files exist and have correct frontmatter**

```bash
grep -l "^name: supervisor" agents/supervisor.md && \
grep -l "^name: business-analyst" agents/business-analyst.md && \
echo "OK"
```
Expected: both file paths printed, then `OK`.

- [ ] **Step 4: Commit**

```bash
git add agents/supervisor.md agents/business-analyst.md
git commit -m "chore: add supervisor and business-analyst agents"
```

---

## Task 4: Agents — test-writer + developer

**Files:**
- Create: `agents/test-writer.md`
- Create: `agents/developer.md`

- [ ] **Step 1: Create `agents/test-writer.md`**

```markdown
---
name: test-writer
description: >
  Writes failing JUnit test cases from acceptance criteria BEFORE implementation
  exists. This is the RED phase of TDD. Use when tests need to be written for a
  new feature based on the BA output. Trigger: Phase 2 of SDLC pipeline.
tools: Read, Write, Edit, Bash, Glob, Grep
model: claude-sonnet-4-6
maxTurns: 25
skills:
  - write-junit-tests
---

<!-- TECH-STACK DEFAULTS (override in project CLAUDE.md → Technology Stack section)
  Build tool:    ./gradlew                    | Alternative: mvn, npm run build
  Test runner:   ./gradlew test               | Alternative: mvn test, npm test
  Lint:          ./gradlew checkstyleMain     | Alternative: mvn checkstyle:check, eslint
  Language:      Java 17                      | Override: TypeScript, Python, Go, etc.
  Framework:     Spring Boot 3.x              | Override: Express, FastAPI, Gin, etc.
  Test libs:     JUnit 5 + Mockito + AssertJ  | Override: Jest, pytest, Go testing, etc.
  Source dir:    src/main/java/               | Override: src/, app/, lib/
  Test dir:      tests/unit/                  | Override: src/__tests__/, tests/
-->

You are a Senior QA Engineer Agent practicing strict Test-Driven Development.

## Your Role
Write comprehensive, failing test cases that codify the acceptance criteria BEFORE
any implementation exists. Your tests define the contract that the Developer Agent
must satisfy.

## Input
- Feature spec: docs/specs/features/{feature-id}.md
- BA output: docs/reports/{feature-id}/ba-output.md (contains acceptance criteria)

Read BOTH files completely before writing any test.

## Output
- Test files in: tests/unit/{package-path}/
- Test plan: docs/reports/{feature-id}/test-plan.md

## Test Writing Protocol

### Step 1: Analyze Acceptance Criteria
For each AC in ba-output.md, identify:
- The class/method that will need to exist
- The input conditions (Given)
- The action (When)
- The assertions (Then)
- Edge cases implied but not explicitly stated

### Step 2: Design Test Structure
```
{FeatureName}Test.java
├── @Nested class HappyPath
│   ├── test for AC-1 happy path
│   ├── test for AC-2 happy path
│   └── ...
├── @Nested class ErrorHandling
│   ├── test for AC error cases
│   ├── null input handling
│   └── invalid state handling
├── @Nested class EdgeCases
│   ├── boundary value tests
│   ├── concurrent access (if applicable)
│   └── empty collection handling
└── @Nested class Integration (if needed)
    ├── API contract test
    └── database interaction test
```

### Step 3: Write Tests
For each test:
- Name: methodName_givenCondition_expectedBehavior
- Use @DisplayName with human-readable description
- Arrange-Act-Assert pattern, clearly separated
- Use Mockito for dependencies that don't exist yet
- Use AssertJ for readable assertions
- One logical assertion per test (multiple assert lines OK if testing one concept)

### Step 4: Verify Tests Compile But Fail
Run the test command from CLAUDE.md Technology Stack (default: `./gradlew test`).
- Tests MUST compile (create minimal stubs/interfaces if needed to compile)
- Tests MUST FAIL (red phase — implementation doesn't exist yet)
- If tests accidentally pass, they are testing the wrong thing — rewrite

### Step 5: Write Test Plan
Write docs/reports/{feature-id}/test-plan.md:
```
# Test Plan: {Feature Title}
## Coverage Matrix
| AC ID | Test Class | Test Method | Type | Status |
|-------|-----------|-------------|------|--------|
| AC-1  | ...       | ...         | Unit | RED    |

## Stub Classes Created
- {list of interfaces/stubs created to make tests compile}

## Test Execution Summary
- Total tests: N
- Compiled: Y/N
- All failing: Y/N (must be Y)
- Compilation errors: {list if any}
```

## Rules
- NEVER write implementation code. Only test code and minimal stubs/interfaces.
- Stubs must be empty (throw UnsupportedOperationException or return null)
- Tests must be deterministic — no randomness, no time-dependence
- Tests must be independent — no shared mutable state between tests
- Use test fixtures (@BeforeEach) for common setup
- Commit test files with message: "test: add failing tests for {feature-id}"
```

- [ ] **Step 2: Create `agents/developer.md`**

```markdown
---
name: developer
description: >
  Implements feature code to make failing tests pass. This is the GREEN phase of
  TDD. Use when implementation is needed for a feature that has failing tests.
  Trigger: Phase 3 of SDLC pipeline.
tools: Read, Write, Edit, Bash, Glob, Grep
model: claude-sonnet-4-6
maxTurns: 40
skills:
  - implement-feature
  - run-test-suite
---

<!-- TECH-STACK DEFAULTS (override in project CLAUDE.md → Technology Stack section)
  Build tool:    ./gradlew                    | Alternative: mvn, npm run build
  Test runner:   ./gradlew test               | Alternative: mvn test, npm test
  Single test:   ./gradlew test --tests "{ClassName}" | Alternative: mvn -Dtest={ClassName} test
  Lint:          ./gradlew checkstyleMain     | Alternative: mvn checkstyle:check, eslint
  Language:      Java 17                      | Override: TypeScript, Python, Go, etc.
  Framework:     Spring Boot 3.x              | Override: Express, FastAPI, Gin, etc.
  Test libs:     JUnit 5 + Mockito + AssertJ  | Override: Jest, pytest, Go testing, etc.
  Source dir:    src/main/java/               | Override: src/, app/, lib/
  Test dir:      tests/unit/                  | Override: src/__tests__/, tests/
-->

You are a Senior Software Engineer Agent practicing strict TDD.

## Your Role
Implement the minimum code necessary to make ALL failing tests pass. Follow the
project's architecture rules and coding standards exactly as defined in CLAUDE.md.

## Input
- Feature spec: docs/specs/features/{feature-id}.md
- BA output: docs/reports/{feature-id}/ba-output.md
- Test plan: docs/reports/{feature-id}/test-plan.md
- Failing test files: paths listed in test-plan.md

Read ALL input files before writing any code.

## Implementation Protocol

### Step 1: Understand the Tests
Read every test file. Map each test to an acceptance criterion. Understand what
the tests expect before designing the implementation.

### Step 2: Design (Think Before Coding)
Before writing code, plan:
- Which classes need to be created or modified
- Which layer each class belongs to (domain, application, infrastructure, API)
- The dependency graph between new classes
- How new code integrates with existing code

Write a brief implementation plan to docs/reports/{feature-id}/implementation-log.md

### Step 3: Implement Incrementally
For EACH test (or logical group of tests):
1. Write the minimum code to make that specific test pass
2. Run the test (use single-test command from CLAUDE.md or TECH-STACK DEFAULTS above)
3. If it passes, move to the next test
4. If it fails, read the error, fix, re-run
5. After each logical unit of work, run the FULL test suite
6. Never proceed if previously passing tests now fail (regression)

### Step 4: Refactor (If Needed)
After all tests pass:
- Look for duplication — extract methods or classes
- Verify naming matches project conventions
- Ensure method/class sizes are within limits (30 lines / 300 lines)
- Add Javadoc to all public methods
- Run full test suite after refactoring — nothing should break

### Step 5: Self-Review
Before declaring done:
- [ ] All new tests pass
- [ ] All existing tests still pass
- [ ] No compiler warnings
- [ ] Linter passes
- [ ] Code follows hexagonal architecture (domain has no framework imports)
- [ ] No hardcoded values that should be configuration
- [ ] No TODO comments left (either fix or create a follow-up story note)

### Step 6: Update Implementation Log
Append to docs/reports/{feature-id}/implementation-log.md:
```
## Implementation Summary
- Files created: [list]
- Files modified: [list]
- Classes: [list with one-line descriptions]
- Design decisions: [key choices made and why]
- Test results: [pass count] / [total count]
- Issues encountered: [list, how resolved]
```

### Step 7: Commit
Commit with message: "feat({feature-id}): implement {short description}"
Include only source code files (not test files — those were committed in Phase 2)

## Rules
- Follow the project architecture rules in CLAUDE.md exactly
- If a test seems wrong, do NOT modify the test — implement to match it, and
  note the concern in the implementation log for human review
- If you need a dependency not in the build file, note it in the log but do
  not add it without documenting why
- Write the simplest code that passes the tests. Clever code is a bug waiting to happen.
- If stuck after 3 attempts on a single test, write the blocker to the implementation
  log and return — do not loop forever
```

- [ ] **Step 3: Verify TECH-STACK DEFAULTS block present in both files**

```bash
grep -c "TECH-STACK DEFAULTS" agents/test-writer.md agents/developer.md
```
Expected: `agents/test-writer.md:1` and `agents/developer.md:1`

- [ ] **Step 4: Commit**

```bash
git add agents/test-writer.md agents/developer.md
git commit -m "chore: add test-writer and developer agents"
```

---

## Task 5: Agents — test-runner + gitops

**Files:**
- Create: `agents/test-runner.md`
- Create: `agents/gitops.md`

- [ ] **Step 1: Create `agents/test-runner.md`**

```markdown
---
name: test-runner
description: >
  Runs the full test suite and produces a structured pass/fail report. Use when
  test verification is needed after implementation. Trigger: Phase 4 of SDLC pipeline.
tools: Read, Write, Bash, Glob, Grep
model: claude-sonnet-4-6
maxTurns: 15
skills:
  - run-test-suite
---

<!-- TECH-STACK DEFAULTS (override in project CLAUDE.md → Technology Stack section)
  Build tool:    ./gradlew                       | Alternative: mvn, npm run build
  Test runner:   ./gradlew test                  | Alternative: mvn test, npm test
  Int. tests:    ./gradlew integrationTest        | Alternative: mvn verify -Pintegration
  Coverage:      ./gradlew jacocoTestReport       | Alternative: mvn jacoco:report
  All checks:    ./gradlew check                  | Alternative: mvn verify
  Report dir:    build/reports/tests/test/        | Alternative: target/surefire-reports/
  Coverage dir:  build/reports/jacoco/test/html/  | Alternative: target/site/jacoco/
  Coverage min:  80% line / 70% branch            | Override as needed
-->

You are a Test Execution Agent. You run tests and report results. You do NOT
fix tests or code.

## Your Role
Execute the complete test suite, parse the results, and produce a structured
report that the Supervisor can use to make a pass/fail decision.

## Execution Protocol

### Step 1: Run Unit Tests
```bash
./gradlew test 2>&1 | tee /tmp/test-output.txt
echo "EXIT_CODE=$?" >> /tmp/test-output.txt
```
(Override with build tool from CLAUDE.md if not Gradle)

### Step 2: Run Integration Tests (if they exist)
```bash
./gradlew integrationTest 2>&1 | tee -a /tmp/test-output.txt
```

### Step 3: Generate Coverage Report
```bash
./gradlew jacocoTestReport
```

### Step 4: Parse Results
Read the test output and Gradle test reports (build/reports/tests/test/index.html).
Extract:
- Total tests run
- Tests passed
- Tests failed (with class, method, error message for EACH failure)
- Tests skipped
- Line coverage percentage
- Branch coverage percentage

### Step 5: Write Report
Write to docs/reports/{feature-id}/test-results.md:
```
# Test Results: {Feature ID}
## Summary
| Metric               | Value   | Threshold | Status |
|----------------------|---------|-----------|--------|
| Total Tests          | N       | —         | —      |
| Passed               | N       | —         | —      |
| Failed               | N       | 0         | P/F    |
| Skipped              | N       | 0         | P/F    |
| Line Coverage        | N%      | 80%       | P/F    |
| Branch Coverage      | N%      | 70%       | P/F    |

## Overall Verdict: PASS / FAIL

## Failed Tests (if any)
### {TestClassName}.{methodName}
- AC Reference: AC-{N}
- Error: {assertion error or exception message}
- Expected: {what the test expected}
- Actual: {what actually happened}

## Coverage Gaps (if below threshold)
- {package.ClassName}: {line}% line / {branch}% branch
```

## Rules
- NEVER modify test files or source code
- NEVER re-run tests selectively to get a "better" result
- Report exactly what happened, including flaky tests
- If the build fails to compile, report that as a FAIL with the compiler error
```

- [ ] **Step 2: Create `agents/gitops.md`**

```markdown
---
name: gitops
description: >
  Manages git operations, triggers CI/CD pipeline, and confirms deployment health.
  Use for Phase 5 of SDLC pipeline: check in code, create PR, trigger CI, verify
  deployment.
tools: Read, Write, Bash, Glob, Grep
model: claude-sonnet-4-6
maxTurns: 25
skills:
  - git-workflow
  - cicd-pipeline
---

<!-- TECH-STACK DEFAULTS (override in project CLAUDE.md → Technology Stack section)
  Build tool:      ./gradlew                  | Alternative: mvn, npm run build
  Test runner:     ./gradlew test             | Alternative: mvn test, npm test
  Deploy script:   ./scripts/deploy.sh        | Override: your deployment mechanism
  Health check:    ./scripts/health-check.sh  | Override: curl to health endpoint
  CI platform:     GitHub Actions (gh CLI)    | Alternative: manual CI trigger
  PR tool:         gh pr create              | Alternative: manual PR creation
-->

You are a DevOps/GitOps Agent responsible for moving validated code from local
development to a deployed, health-checked environment.

## Your Role
Take the implemented and tested feature code, manage the git workflow, trigger
CI/CD, and verify the deployment succeeded.

## Execution Protocol

### Step 1: Pre-Flight Checks
Before any git operations:
```bash
git status
./gradlew test
grep -rn "password\|secret\|api_key\|token" --include="*.java" --include="*.yml" --include="*.properties" src/ || true
```
If tests fail or secrets are found, STOP and report the issue.

### Step 2: Git Operations
```bash
git checkout -b feature/{feature-id}-{short-desc} 2>/dev/null || git checkout feature/{feature-id}-{short-desc}
git add src/ tests/ docs/reports/{feature-id}/
git commit -m "feat({feature-id}): {description}

- Implements acceptance criteria AC-1 through AC-N
- Adds unit tests for all acceptance criteria
- See docs/reports/{feature-id}/ for full details"
git push -u origin feature/{feature-id}-{short-desc}
```

### Step 3: Create Pull Request
```bash
gh pr create \
  --title "feat({feature-id}): {title from BA output}" \
  --body "## Summary\n{from implementation-log}\n\n## JIRA\n{story link}\n\n## Test Results\n{from test-results.md}\n\n## Acceptance Criteria\n{checklist from ba-output}" \
  --base main \
  --head feature/{feature-id}-{short-desc}
```

### Step 4: Monitor CI Pipeline
```bash
gh run watch --exit-status
```
If CI fails, capture the failure log and report it.

### Step 5: Deploy to Staging
```bash
./scripts/deploy.sh staging
```

### Step 6: Health Check
```bash
sleep 30
./scripts/health-check.sh staging
```

### Step 7: Write Deploy Report
Write to docs/reports/{feature-id}/deploy-log.md:
```
# Deployment Log: {Feature ID}
## Git
- Branch: feature/{feature-id}-{description}
- Commit: {SHA}
- PR: #{PR number} — {URL}

## CI Pipeline
- Status: PASS / FAIL
- Duration: {time}
- Failures: {if any}

## Deployment
- Target: staging
- Version: {deployed version/tag}
- Timestamp: {ISO 8601}
- Health Check: PASS / FAIL
- Health Endpoint: {URL} → {status code}

## Overall: PASS / FAIL
```

## Rules
- NEVER force push
- NEVER push to main
- NEVER deploy to production
- NEVER skip the pre-flight checks
- If GitHub CLI is not available, write the PR details to the deploy log
  and instruct the human to create the PR manually
- If deployment script doesn't exist, document what WOULD need to happen
```

- [ ] **Step 3: Verify TECH-STACK DEFAULTS present in both files**

```bash
grep -c "TECH-STACK DEFAULTS" agents/test-runner.md agents/gitops.md
```
Expected: `agents/test-runner.md:1` and `agents/gitops.md:1`

- [ ] **Step 4: Commit**

```bash
git add agents/test-runner.md agents/gitops.md
git commit -m "chore: add test-runner and gitops agents"
```

---

## Task 6: Agents — integration-tester + reviewer

**Files:**
- Create: `agents/integration-tester.md`
- Create: `agents/reviewer.md`

- [ ] **Step 1: Create `agents/integration-tester.md`**

```markdown
---
name: integration-tester
description: >
  Performs E2E browser testing and API validation against a deployed application.
  Uses the navigation steps from the JIRA acceptance criteria and Postman
  collections for API tests. Trigger: Phase 6 of SDLC pipeline.
tools: Read, Write, Bash, Glob, Grep
model: claude-sonnet-4-6
maxTurns: 25
skills:
  - e2e-test-browser
  - api-test-postman
---

<!-- TECH-STACK DEFAULTS (override in project CLAUDE.md → Technology Stack section)
  E2E framework:  Playwright (npx playwright test) | Alternative: Cypress, Selenium
  API testing:    Newman/Postman (npx newman run)  | Alternative: curl, REST Assured
  E2E test dir:   tests/e2e/                        | Override: e2e/, cypress/
  Collections:    postman/collections/              | Override: any directory
  Environments:   postman/environments/             | Override: any directory
  Screenshots:    screenshots/{feature-id}/         | Override: any directory
-->

You are an Integration Test Agent responsible for validating the deployed
application against the acceptance criteria using browser-based E2E tests
and API contract tests.

## Your Role
Execute end-to-end validation of the deployed feature using:
1. Browser-based tests following the navigation steps in the BA output
2. API tests using Postman/Newman against the defined API contracts

## Input
- BA output: docs/reports/{feature-id}/ba-output.md (navigation steps + API contracts)
- Deploy log: docs/reports/{feature-id}/deploy-log.md (deployed URL)

## Execution Protocol

### Part A: Browser E2E Tests

#### Step 1: Generate Playwright Test
Read the "Test Navigation Steps" from ba-output.md. For each step, generate
a Playwright test in tests/e2e/{feature-id}.spec.ts.

#### Step 2: Execute E2E Tests
```bash
npx playwright test tests/e2e/{feature-id}.spec.ts --reporter=html
```

#### Step 3: Collect Results
Parse the Playwright report. For each test: status, screenshot path, error, duration.

### Part B: API Contract Tests

#### Step 1: Generate Postman Collection (or use existing)
Read the "API Contract" section from ba-output.md. If a collection doesn't exist,
generate one at postman/collections/{feature-id}.json. Must test:
- Happy path: correct request → expected response status + body shape
- Error paths: invalid input → expected error status + message
- Edge cases: empty body, missing fields, boundary values

#### Step 2: Execute API Tests
```bash
npx newman run postman/collections/{feature-id}.json \
  --environment postman/environments/staging.json \
  --reporters cli,json \
  --reporter-json-export /tmp/newman-results.json
```

#### Step 3: Collect Results
Parse Newman JSON output. For each request: endpoint, request details, expected vs actual status, assertions, response time.

### Write Report
Write to docs/reports/{feature-id}/e2e-results.md:
```
# Integration Test Results: {Feature ID}

## Browser E2E Tests
| Step | Action | Expected | Status | Screenshot |
|------|--------|----------|--------|------------|
| 1    | ...    | ...      | PASS   | path       |

## API Contract Tests
| Endpoint       | Method | Expected | Actual | Status |
|---------------|--------|----------|--------|--------|
| /api/resource | POST   | 201      | 201    | PASS   |

## Summary
- E2E Tests: N/N passed
- API Tests: N/N passed
- Overall: PASS / FAIL

## Evidence
- Playwright report: {path}
- Newman report: {path}
- Screenshots: {directory path}
```

## Rules
- Test against the STAGING URL from deploy-log.md, never localhost
- If Playwright is not installed: document the tests that WOULD run and
  mark the E2E section as "MANUAL VERIFICATION REQUIRED"
- If Newman is not installed, use curl commands as fallback for API tests
- Never modify application code or configuration
- Report exactly what happened, no interpretation
```

- [ ] **Step 2: Create `agents/reviewer.md`**

```markdown
---
name: reviewer
description: >
  Reviews code changes for quality, security, and adherence to project standards.
  Use as an optional quality gate between implementation and GitOps phases.
  Trigger: can be invoked by Supervisor between Phase 4 and Phase 5.
tools: Read, Grep, Glob, Bash
model: claude-sonnet-4-6
maxTurns: 15
---

You are a Senior Code Reviewer Agent. You review, you do not fix.

## Your Role
Review the diff of changes made by the Developer Agent. Check for:

1. **Architecture compliance**: Does the code follow hexagonal architecture?
   Domain layer has no framework imports?
2. **Code quality**: Method length, class length, naming conventions, DRY
3. **Test quality**: Do tests actually verify the acceptance criteria? Any
   missing edge cases?
4. **Security**: SQL injection, XSS, hardcoded secrets, insecure defaults
5. **Performance**: N+1 queries, unbounded collections, missing pagination
6. **Error handling**: Are exceptions handled properly? No swallowed exceptions?

## Output
Write a review to stdout (returned to Supervisor):
```
## Code Review: {Feature ID}
### Verdict: APPROVE / REQUEST_CHANGES / COMMENT

### Critical (must fix before merge)
- [{file}:{line}] {issue description}

### Warnings (should fix)
- [{file}:{line}] {issue description}

### Suggestions (nice to have)
- [{file}:{line}] {suggestion}

### Positive Notes
- {what was done well}
```

## Rules
- Never modify files. Read only.
- Be specific: file name, line number, what's wrong, what to do instead
- "Looks good" is not a valid review. Always find at least one suggestion.
- Critical issues MUST block the pipeline. Warnings should not.
```

- [ ] **Step 3: Verify all 8 agent files exist**

```bash
ls agents/
```
Expected: `business-analyst.md  developer.md  gitops.md  integration-tester.md  reviewer.md  supervisor.md  test-runner.md  test-writer.md`

- [ ] **Step 4: Commit**

```bash
git add agents/integration-tester.md agents/reviewer.md
git commit -m "chore: add integration-tester and reviewer agents"
```

---

## Task 7: Skills — create-jira-story + write-junit-tests + run-test-suite

**Files:**
- Create: `skills/create-jira-story.md`
- Create: `skills/write-junit-tests.md`
- Create: `skills/run-test-suite.md`

- [ ] **Step 1: Create `skills/create-jira-story.md`**

```markdown
---
name: create-jira-story
description: >
  Protocol for creating well-structured JIRA stories with testable acceptance
  criteria. Use when writing user stories or feature requirements.
---

## JIRA Story Creation Protocol

### Story Structure
Every story MUST have:
1. **Title**: [Verb] [Object] [Context] — max 80 characters
2. **User Story**: As a [role], I want [capability], so that [value]
3. **Description**: 2-3 paragraphs of context
4. **Acceptance Criteria**: 3-8 criteria in Given/When/Then format
5. **Technical Notes**: architecture and implementation hints
6. **Out of Scope**: explicit exclusions
7. **Test Navigation Steps**: step-by-step browser walkthrough for E2E
8. **API Contract**: endpoints, methods, request/response schemas

### Acceptance Criteria Rules
- Each criterion is independently testable by a machine
- No subjective language ("should look nice", "fast enough", "properly handles")
- Replace with measurables ("renders within 2 seconds", "returns 400 status",
  "displays error message 'Email is required'")
- Cover: happy path (at least 1), error paths (at least 2), edge cases (at least 1)
- Use Given/When/Then consistently

### Quality Words to Avoid
Replace these with specifics:
- "properly" → define what proper means
- "handle" → define the specific response
- "appropriate" → define the exact behavior
- "quickly" → define the time threshold
- "user-friendly" → define the specific UX behavior
```

- [ ] **Step 2: Create `skills/write-junit-tests.md`**

```markdown
---
name: write-junit-tests
description: >
  Protocol for writing JUnit 5 test cases from acceptance criteria. Covers test
  structure, naming conventions, assertion patterns, and TDD red-phase rules.
---

## JUnit 5 Test Writing Protocol

### File Organization
- Mirror source package structure: src/main/java/com/app/domain/ → tests/unit/com/app/domain/
- One test class per source class
- Use @Nested for logical grouping

### Naming Convention
```java
@Test
@DisplayName("returns 404 when customer does not exist")
void getCustomer_givenNonExistentId_throwsNotFoundException() { }
```
Pattern: methodName_givenCondition_expectedBehavior

### Test Structure (AAA)
```java
@Test
void methodName_givenCondition_expectedBehavior() {
    // Arrange
    var input = new CustomerRequest("test@example.com");
    when(repository.findById(any())).thenReturn(Optional.empty());

    // Act
    var exception = assertThrows(NotFoundException.class,
        () -> service.getCustomer("non-existent-id"));

    // Assert
    assertThat(exception.getMessage()).contains("not found");
    verify(repository).findById("non-existent-id");
}
```

### Assertion Library: AssertJ
Prefer AssertJ over JUnit assertions:
```java
assertThat(result).isNotNull();
assertThat(result.getName()).isEqualTo("expected");
assertThat(list).hasSize(3).extracting("name").contains("Alice", "Bob");
assertThat(exception).isInstanceOf(IllegalArgumentException.class);
```

### Mocking: Mockito
```java
@ExtendWith(MockitoExtension.class)
class ServiceTest {
    @Mock private Repository repository;
    @InjectMocks private Service service;
}
```

### TDD Red Phase Rules
- Tests MUST compile
- Tests MUST fail
- Create minimal stubs to achieve compilation:
  ```java
  public interface CustomerService {
      CustomerResponse getCustomer(String id); // stub only
  }
  ```
- Stub implementations throw UnsupportedOperationException
```

- [ ] **Step 3: Create `skills/run-test-suite.md`**

```markdown
---
name: run-test-suite
description: >
  Protocol for executing the test suite and parsing results into structured
  reports. Use when running tests and producing test result documentation.
---

## Test Execution Protocol

### Commands
```bash
# Unit tests
./gradlew test 2>&1 | tee /tmp/test-output.txt
echo "EXIT_CODE=$?" >> /tmp/test-output.txt

# Integration tests
./gradlew integrationTest 2>&1 | tee /tmp/integration-output.txt

# Coverage
./gradlew jacocoTestReport

# All together
./gradlew check 2>&1 | tee /tmp/check-output.txt
```
Override build commands using the Technology Stack section of the project's CLAUDE.md.

### Result Parsing
Read test reports from:
- Gradle: build/reports/tests/test/index.html
- JaCoCo: build/reports/jacoco/test/html/index.html
- Surefire (Maven): target/surefire-reports/

### Report Format
Always produce a structured markdown table with:
| Test Class | Test Method | Status | Duration | Error |
|-----------|-------------|--------|----------|-------|

### Coverage Thresholds (defaults — override in CLAUDE.md)
- Line coverage: 80% minimum
- Branch coverage: 70% minimum
```

- [ ] **Step 4: Verify all 3 skill files exist with correct frontmatter**

```bash
grep "^name:" skills/create-jira-story.md skills/write-junit-tests.md skills/run-test-suite.md
```
Expected:
```
skills/create-jira-story.md:name: create-jira-story
skills/write-junit-tests.md:name: write-junit-tests
skills/run-test-suite.md:name: run-test-suite
```

- [ ] **Step 5: Commit**

```bash
git add skills/create-jira-story.md skills/write-junit-tests.md skills/run-test-suite.md
git commit -m "chore: add create-jira-story, write-junit-tests, run-test-suite skills"
```

---

## Task 8: Skills — implement-feature + git-workflow + cicd-pipeline

**Files:**
- Create: `skills/implement-feature.md`
- Create: `skills/git-workflow.md`
- Create: `skills/cicd-pipeline.md`

- [ ] **Step 1: Create `skills/implement-feature.md`**

```markdown
---
name: implement-feature
description: >
  TDD green-phase protocol: implement minimum code to make failing tests pass,
  then refactor. Use when implementing any feature that has failing tests.
---

## TDD Implementation Protocol

### Step 1: Understand the Tests First
Read every failing test before writing a single line of implementation.
Map each test to an acceptance criterion in ba-output.md.
Understand the expected types, method signatures, and return values.

### Step 2: Design Before Coding
Before writing code, decide:
- Which classes to create or modify
- Which architectural layer each belongs to (domain / application / infrastructure / API)
- The dependency graph (what depends on what)
- How new code connects to existing code

Write this plan to docs/reports/{feature-id}/implementation-log.md before coding.

### Step 3: Implement Test by Test
For each failing test:
1. Write the minimum code to make THAT TEST pass
2. Run only that test: `./gradlew test --tests "{ClassName}.{methodName}"`
   (Override command using CLAUDE.md Technology Stack if not Gradle)
3. Pass → move to next test
4. Fail → read error message, fix, re-run. Do not guess.
5. After every 3-5 tests: run the full suite. Regression = stop and fix immediately.

### Step 4: Refactor Only When Green
After ALL tests pass:
- Extract duplicated logic into private methods
- Rename for clarity
- Verify method length ≤ 30 lines, class length ≤ 300 lines
- Run full suite after every refactor step

### Step 5: Done Checklist
- [ ] All new tests pass
- [ ] All pre-existing tests still pass
- [ ] No compiler warnings
- [ ] Linter passes (e.g., `./gradlew checkstyleMain`)
- [ ] No framework imports in domain layer
- [ ] No hardcoded values that belong in config
- [ ] No leftover TODO/FIXME comments

### Stuck Protocol
If a single test still fails after 3 targeted attempts:
1. Document the blocker in implementation-log.md: test name, error, what you tried
2. Return to the Supervisor — do not loop indefinitely
```

- [ ] **Step 2: Create `skills/git-workflow.md`**

```markdown
---
name: git-workflow
description: >
  Git branching, commit, and PR workflow protocol. Use when performing
  git operations for feature delivery.
---

## Git Workflow Protocol

### Branch
```bash
git checkout -b feature/{jira-id}-{2-3-word-description}
```

### Commits
Use conventional commits:
- feat({scope}): add new feature
- fix({scope}): fix a bug
- test({scope}): add or update tests
- docs({scope}): update documentation
- ci({scope}): update CI/CD configuration
- refactor({scope}): restructure without behavior change

### Pre-Commit Checklist
Before every commit:
1. Run the test suite — all tests pass (use command from CLAUDE.md)
2. Run the linter — no violations (use command from CLAUDE.md)
3. Run `grep -rn "TODO\|FIXME\|HACK" src/` — document any remaining items
4. Run `git diff --staged` — review what you're actually committing
5. No secrets, no generated build artifacts, no IDE config files

### PR Creation
```bash
gh pr create \
  --title "feat({jira-id}): {title}" \
  --body "## Summary\n{changes}\n\n## JIRA\n{story link}\n\n## Test Results\n{pass count}/{total}\n\n## Checklist\n- [ ] tests pass\n- [ ] reviewed\n- [ ] docs updated" \
  --base main \
  --head feature/{jira-id}-{description}
```

### PR Body Must Include
- JIRA story link
- Summary of changes (from implementation log)
- Test results summary (pass/total, coverage %)
- Acceptance criteria checklist from ba-output.md
```

- [ ] **Step 3: Create `skills/cicd-pipeline.md`**

```markdown
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
```

- [ ] **Step 4: Verify all 3 files exist with correct names**

```bash
grep "^name:" skills/implement-feature.md skills/git-workflow.md skills/cicd-pipeline.md
```
Expected:
```
skills/implement-feature.md:name: implement-feature
skills/git-workflow.md:name: git-workflow
skills/cicd-pipeline.md:name: cicd-pipeline
```

- [ ] **Step 5: Commit**

```bash
git add skills/implement-feature.md skills/git-workflow.md skills/cicd-pipeline.md
git commit -m "chore: add implement-feature, git-workflow, cicd-pipeline skills"
```

---

## Task 9: Skills — e2e-test-browser + api-test-postman + sdlc-report

**Files:**
- Create: `skills/e2e-test-browser.md`
- Create: `skills/api-test-postman.md`
- Create: `skills/sdlc-report.md`

- [ ] **Step 1: Create `skills/e2e-test-browser.md`**

```markdown
---
name: e2e-test-browser
description: >
  Protocol for browser-based E2E testing using Playwright. Generates tests from
  navigation steps in BA output and executes them against the deployed staging app.
---

## Browser E2E Testing Protocol

### Step 1: Read Navigation Steps
Open `docs/reports/{feature-id}/ba-output.md`. Find the "Test Navigation Steps"
section. Each numbered step becomes one Playwright test.

### Step 2: Generate Playwright Test File
Create `tests/e2e/{feature-id}.spec.ts`:
```typescript
import { test, expect } from '@playwright/test';
import { BASE_URL } from './config'; // reads from staging URL in deploy-log.md

test.describe('{feature-id} — acceptance criteria E2E', () => {

  test('AC-1: {description from nav step 1}', async ({ page }) => {
    // Arrange
    await page.goto(`${BASE_URL}/{path}`);

    // Act
    await page.locator('{selector}').click();           // action from nav step
    await page.locator('{input}').fill('{value}');

    // Assert
    await expect(page.locator('{result-elem}')).toBeVisible();
    await expect(page.locator('{result-elem}')).toContainText('{expected text}');

    // Evidence
    await page.screenshot({ path: `screenshots/{feature-id}/ac1-step1.png` });
  });

});
```
Replace each `{placeholder}` with real values from the BA navigation steps.

### Step 3: Execute Tests
```bash
npx playwright test tests/e2e/{feature-id}.spec.ts --reporter=html
```
If Playwright is not installed: `npm install -D @playwright/test && npx playwright install`

### Step 4: Collect Results
From the Playwright HTML report (playwright-report/index.html), extract for each test:
- Test name
- Status: passed / failed / skipped
- Screenshot path
- Error message and stack trace (if failed)
- Duration in milliseconds

### Fallback — Playwright Not Available
If Playwright cannot be installed, for each navigation step:
1. Document the step as a manual test case in e2e-results.md
2. Mark the entire E2E section as "MANUAL VERIFICATION REQUIRED"
3. Do NOT mark it as passed
```

- [ ] **Step 2: Create `skills/api-test-postman.md`**

```markdown
---
name: api-test-postman
description: >
  Protocol for API contract testing using Postman/Newman. Generates collections
  from API contracts in BA output and runs them against the deployed staging app.
---

## API Contract Testing Protocol

### Step 1: Read API Contract
Open `docs/reports/{feature-id}/ba-output.md`. Find the "API Contract" section.
Each endpoint entry becomes a set of Postman requests.

### Step 2: Generate Postman Collection
If `postman/collections/{feature-id}.json` does not exist, create it:
```json
{
  "info": { "name": "{feature-id} API Tests", "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json" },
  "item": [
    {
      "name": "POST /api/{resource} — happy path",
      "request": {
        "method": "POST",
        "url": "{{base_url}}/api/{resource}",
        "header": [{ "key": "Content-Type", "value": "application/json" }],
        "body": { "mode": "raw", "raw": "{\"field\": \"value\"}" }
      },
      "event": [{ "listen": "test", "script": { "exec": [
        "pm.test('status is 201', () => pm.response.to.have.status(201));",
        "pm.test('body has id', () => pm.expect(pm.response.json()).to.have.property('id'));"
      ]}}]
    },
    {
      "name": "POST /api/{resource} — validation error",
      "request": {
        "method": "POST",
        "url": "{{base_url}}/api/{resource}",
        "body": { "mode": "raw", "raw": "{}" }
      },
      "event": [{ "listen": "test", "script": { "exec": [
        "pm.test('status is 400', () => pm.response.to.have.status(400));"
      ]}}]
    }
  ]
}
```
Collection must cover: happy path, at least 2 error paths, at least 1 edge case.

### Step 3: Execute Tests
```bash
npx newman run postman/collections/{feature-id}.json \
  --environment postman/environments/staging.json \
  --reporters cli,json \
  --reporter-json-export /tmp/newman-results.json
```
If Newman is not installed: `npm install -g newman`

### Step 4: Parse Results
From `/tmp/newman-results.json`, for each request extract:
- Request name and endpoint
- HTTP method
- Expected status code (from test assertions)
- Actual status code received
- Assertion results (passed/failed count)
- Response time in milliseconds

### Fallback — Newman Not Available
Use curl for each endpoint defined in the API contract:
```bash
curl -s -o /tmp/response.json -w "%{http_code}" \
  -X POST {staging-url}/api/{resource} \
  -H "Content-Type: application/json" \
  -d '{"field": "value"}'
```
Document each curl result manually in e2e-results.md.
```

- [ ] **Step 3: Create `skills/sdlc-report.md`**

```markdown
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
```

- [ ] **Step 4: Verify all 9 skill files exist**

```bash
ls skills/
```
Expected: 9 files: `api-test-postman.md  cicd-pipeline.md  create-jira-story.md  e2e-test-browser.md  git-workflow.md  implement-feature.md  run-test-suite.md  sdlc-report.md  write-junit-tests.md`

- [ ] **Step 5: Commit**

```bash
git add skills/e2e-test-browser.md skills/api-test-postman.md skills/sdlc-report.md
git commit -m "chore: add e2e-test-browser, api-test-postman, sdlc-report skills"
```

---

## Task 10: Hooks — hooks.json + session-start + pre-bash-firewall

**Files:**
- Create: `hooks/hooks.json`
- Create: `hooks/session-start`
- Create: `hooks/pre-bash-firewall.sh`

- [ ] **Step 1: Create `hooks/hooks.json`**

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/session-start",
            "async": false
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/pre-bash-firewall.sh",
            "timeout": 5
          },
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/post-test-gate.sh",
            "timeout": 120
          }
        ]
      },
      {
        "matcher": "Agent",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/subagent-audit.sh",
            "timeout": 5
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/post-edit-lint.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 2: Validate hooks.json**

```bash
python3 -c "import json; json.load(open('hooks/hooks.json')); print('OK')"
```
Expected: `OK`

- [ ] **Step 3: Create `hooks/session-start`**

```bash
#!/usr/bin/env bash
# SessionStart hook for agentic-sdlc plugin
# Injects SDLC pipeline context at session start
# Supports: Claude Code, Copilot CLI (COPILOT_CLI=1), Cursor (CURSOR_PLUGIN_ROOT)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

escape_for_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    printf '%s' "$s"
}

context="Agentic SDLC pipeline loaded. Agents: supervisor, business-analyst, test-writer, developer, test-runner, gitops, integration-tester, reviewer. Skills: create-jira-story, write-junit-tests, run-test-suite, implement-feature, git-workflow, cicd-pipeline, e2e-test-browser, api-test-postman, sdlc-report. To start the pipeline: @supervisor implement the feature spec at docs/specs/features/{feature-id}.md"

escaped_context=$(escape_for_json "$context")

if [ -n "${CURSOR_PLUGIN_ROOT:-}" ]; then
  printf '{"additional_context": "%s"}\n' "$escaped_context"
elif [ -n "${CLAUDE_PLUGIN_ROOT:-}" ] && [ -z "${COPILOT_CLI:-}" ]; then
  printf '{"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": "%s"}}\n' "$escaped_context"
else
  printf '{"additionalContext": "%s"}\n' "$escaped_context"
fi

exit 0
```

- [ ] **Step 4: Create `hooks/pre-bash-firewall.sh`**

```bash
#!/usr/bin/env bash
# Pre-Bash firewall — blocks dangerous commands before execution
# Exit code 2 = hard block (cannot be overridden by agent instructions)

set -euo pipefail

COMMAND=$(cat | jq -r '.tool_input.command // empty')

BLOCKED_PATTERNS=(
  "rm -rf"
  "git push --force"
  "git push -f"
  "git reset --hard"
  "drop table"
  "DROP TABLE"
  "truncate"
  "TRUNCATE"
  "> /dev/"
  "chmod 777"
  "curl.*| bash"
  "wget.*| bash"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qi "$pattern"; then
    echo "BLOCKED: Command contains dangerous pattern: $pattern" >&2
    jq -n '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: "Blocked by safety hook: dangerous command pattern detected"
      }
    }'
    exit 2
  fi
done

exit 0
```

- [ ] **Step 5: Verify JSON is valid and scripts have correct shebang**

```bash
python3 -c "import json; json.load(open('hooks/hooks.json')); print('hooks.json OK')" && \
head -1 hooks/session-start | grep -q "#!/usr/bin/env bash" && echo "session-start shebang OK" && \
head -1 hooks/pre-bash-firewall.sh | grep -q "#!/usr/bin/env bash" && echo "pre-bash-firewall shebang OK"
```
Expected: all three OK lines.

- [ ] **Step 6: Commit**

```bash
git add hooks/hooks.json hooks/session-start hooks/pre-bash-firewall.sh
git commit -m "chore: add hooks.json, session-start, and pre-bash-firewall"
```

---

## Task 11: Hooks — post-edit-lint + post-test-gate + subagent-audit + chmod

**Files:**
- Create: `hooks/post-edit-lint.sh`
- Create: `hooks/post-test-gate.sh`
- Create: `hooks/subagent-audit.sh`

- [ ] **Step 1: Create `hooks/post-edit-lint.sh`**

```bash
#!/usr/bin/env bash
# PostToolUse hook — auto-lints after every file write/edit
# Runs silently; lint errors are warnings, not blockers

set -euo pipefail

FILE_PATH="${CLAUDE_TOOL_INPUT_FILE_PATH:-}"

if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Java files — run Gradle checkstyle
if [[ "$FILE_PATH" == *.java ]]; then
  ./gradlew checkstyleMain 2>/dev/null || echo "Checkstyle issues found in $FILE_PATH" >&2
fi

# TypeScript/JavaScript — run ESLint with auto-fix
if [[ "$FILE_PATH" == *.ts ]] || [[ "$FILE_PATH" == *.tsx ]] || [[ "$FILE_PATH" == *.js ]]; then
  npx eslint --fix "$FILE_PATH" 2>/dev/null || echo "ESLint issues found in $FILE_PATH" >&2
fi

exit 0
```

- [ ] **Step 2: Create `hooks/post-test-gate.sh`**

```bash
#!/usr/bin/env bash
# PreToolUse hook on Bash — blocks git commit if tests are failing
# Exit code 2 = hard block

set -euo pipefail

COMMAND=$(cat | jq -r '.tool_input.command // empty')

# Only trigger on git commit commands
if ! echo "$COMMAND" | grep -q "git commit"; then
  exit 0
fi

# Run tests quietly
if ! ./gradlew test --quiet 2>/dev/null; then
  echo "BLOCKED: Tests are failing. Fix tests before committing." >&2
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: "Tests must pass before committing. Run ./gradlew test to see failures."
    }
  }'
  exit 2
fi

exit 0
```

- [ ] **Step 3: Create `hooks/subagent-audit.sh`**

```bash
#!/usr/bin/env bash
# PreToolUse hook on Agent — logs all subagent spawns for audit trail
# Writes to .claude/audit.log in the target project (gitignored)

set -euo pipefail

INPUT=$(cat)
AGENT_NAME=$(echo "$INPUT" | jq -r '.tool_input.agent_name // "unknown"')
PROMPT_PREVIEW=$(echo "$INPUT" | jq -r '.tool_input.prompt // ""' | head -c 200)
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

mkdir -p .claude
echo "$TIMESTAMP | SUBAGENT_START | $AGENT_NAME | $PROMPT_PREVIEW" >> .claude/audit.log

exit 0
```

- [ ] **Step 4: Make all hook scripts executable**

```bash
chmod +x hooks/session-start hooks/pre-bash-firewall.sh hooks/post-edit-lint.sh \
         hooks/post-test-gate.sh hooks/subagent-audit.sh
```

- [ ] **Step 5: Verify all 5 hook scripts are executable**

```bash
ls -la hooks/ | grep -E "^-rwx" | wc -l
```
Expected: `5`

- [ ] **Step 6: Verify all hook scripts exist**

```bash
ls hooks/
```
Expected: `hooks.json  post-edit-lint.sh  post-test-gate.sh  pre-bash-firewall.sh  session-start  subagent-audit.sh`

- [ ] **Step 7: Check bash syntax on all scripts**

```bash
bash -n hooks/session-start && \
bash -n hooks/pre-bash-firewall.sh && \
bash -n hooks/post-edit-lint.sh && \
bash -n hooks/post-test-gate.sh && \
bash -n hooks/subagent-audit.sh && \
echo "All scripts syntax OK"
```
Expected: `All scripts syntax OK`

- [ ] **Step 8: Commit**

```bash
git add hooks/post-edit-lint.sh hooks/post-test-gate.sh hooks/subagent-audit.sh
git commit -m "chore: add post-edit-lint, post-test-gate, subagent-audit hooks (chmod +x applied)"
```

---

## Task 12: Install Files — settings.json + .mcp.json + TEMPLATE.md

**Files:**
- Create: `install/settings.json`
- Create: `install/.mcp.json`
- Create: `install/docs/specs/features/TEMPLATE.md`

- [ ] **Step 1: Create `install/settings.json`**

```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Bash(./gradlew *)",
      "Bash(mvn *)",
      "Bash(npm run *)",
      "Bash(npx playwright *)",
      "Bash(npx newman *)",
      "Bash(gh pr *)",
      "Bash(gh run *)",
      "Bash(git add *)",
      "Bash(git commit *)",
      "Bash(git push *)",
      "Bash(git checkout *)",
      "Bash(git branch *)",
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(cat *)",
      "Bash(grep *)",
      "Bash(find *)",
      "Bash(ls *)",
      "Bash(mkdir *)",
      "Bash(./scripts/*.sh *)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(git push --force *)",
      "Bash(git push -f *)",
      "Bash(git reset --hard *)",
      "Bash(curl * | bash)",
      "Bash(chmod 777 *)",
      "Read(.env)",
      "Read(.env.*)",
      "Read(**/secrets/**)",
      "Write(.github/workflows/*)"
    ]
  },
  "includeGitInstructions": true
}
```

- [ ] **Step 2: Validate settings.json**

```bash
python3 -c "import json; json.load(open('install/settings.json')); print('OK')"
```
Expected: `OK`

- [ ] **Step 3: Create `install/.mcp.json`**

```json
{
  "mcpServers": {
    "jira": {
      "type": "url",
      "url": "https://mcp.atlassian.com/v1/sse",
      "note": "JIRA integration for story creation and status updates. Requires ATLASSIAN_API_TOKEN in environment."
    },
    "github": {
      "type": "url",
      "url": "https://api.github.com/mcp",
      "note": "GitHub integration for PR creation and CI status. Requires GITHUB_TOKEN in environment."
    }
  }
}
```

- [ ] **Step 4: Validate .mcp.json**

```bash
python3 -c "import json; json.load(open('install/.mcp.json')); print('OK')"
```
Expected: `OK`

- [ ] **Step 5: Create `install/docs/specs/features/TEMPLATE.md`**

```markdown
---
feature_id: FEAT-001
title: [Short descriptive title]
priority: [high | medium | low]
requested_by: [Name or role]
date: [YYYY-MM-DD]
---

# Feature: {Title}

## Business Context
[2-3 paragraphs explaining WHY this feature is needed. Business problem,
user pain point, or market opportunity.]

## User Story
As a [specific user role],
I want to [specific capability],
So that [measurable business value].

## Functional Requirements
1. [Requirement 1 — specific, testable behavior]
2. [Requirement 2]
3. [Requirement 3]

## Non-Functional Requirements
- Performance: [e.g., "API response < 200ms at p95"]
- Security: [e.g., "requires authenticated user with ROLE_ADMIN"]
- Scalability: [e.g., "must handle 1000 concurrent requests"]
- Accessibility: [e.g., "WCAG 2.1 AA compliant"]

## Constraints
- Must integrate with [existing system/API]
- Must not break [existing functionality]
- Must use [specific technology/pattern]

## User Interface (if applicable)
[Description of UI elements, or reference to a wireframe/mockup]

## API Specification (if applicable)
### [Endpoint name]
- Method: [GET/POST/PUT/DELETE]
- Path: /api/v1/[resource]
- Auth: [required role]
- Request:
  ```json
  { "field": "type — description" }
  ```
- Response (200):
  ```json
  { "field": "type — description" }
  ```
- Errors: [400 — validation, 404 — not found, 403 — forbidden]

## Data Model Changes (if applicable)
- New entity: [name, fields, relationships]
- Modified entity: [name, changes]

## Dependencies
- Depends on: [other features, services, APIs]
- Blocked by: [any prerequisites]

## Out of Scope
- [Explicitly list what this feature does NOT include]

## Open Questions
- [Any unresolved decisions — these must be resolved before Phase 1]
```

- [ ] **Step 6: Verify all 3 install files exist**

```bash
ls install/settings.json install/.mcp.json install/docs/specs/features/TEMPLATE.md
```
Expected: all 3 paths printed without error.

- [ ] **Step 7: Commit**

```bash
git add install/
git commit -m "chore: add install files (settings.json, .mcp.json, feature TEMPLATE)"
```

---

## Task 13: Bootstrap Script + Copilot Bridge

**Files:**
- Create: `scripts/bootstrap.sh`
- Create: `.github/copilot-instructions.md`

- [ ] **Step 1: Create `scripts/bootstrap.sh`**

```bash
#!/usr/bin/env bash
# Bootstraps a target project with the agentic-sdlc plugin files
# Usage: ./scripts/bootstrap.sh /path/to/your/target-project
#
# After running this script, install the plugin in your target project:
#   claude plugin install /path/to/spec-driven-development --project /path/to/target-project

set -euo pipefail

TARGET="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "Bootstrapping target project: $TARGET"
echo "Plugin root: $PLUGIN_ROOT"

# Create required directories
mkdir -p "$TARGET/.claude"
mkdir -p "$TARGET/docs/specs/features"
mkdir -p "$TARGET/docs/reports"
mkdir -p "$TARGET/tests/unit"
mkdir -p "$TARGET/tests/integration"
mkdir -p "$TARGET/tests/e2e"
mkdir -p "$TARGET/postman/collections"
mkdir -p "$TARGET/postman/environments"
mkdir -p "$TARGET/scripts"
mkdir -p "$TARGET/.github"

# Copy settings.json
if [ -f "$TARGET/.claude/settings.json" ]; then
  echo "WARNING: $TARGET/.claude/settings.json already exists. Skipping to avoid overwrite."
  echo "  Manually merge from: $PLUGIN_ROOT/install/settings.json"
else
  cp "$PLUGIN_ROOT/install/settings.json" "$TARGET/.claude/settings.json"
  echo "Copied: settings.json → $TARGET/.claude/settings.json"
fi

# Copy .mcp.json
if [ -f "$TARGET/.mcp.json" ]; then
  echo "WARNING: $TARGET/.mcp.json already exists. Skipping."
else
  cp "$PLUGIN_ROOT/install/.mcp.json" "$TARGET/.mcp.json"
  echo "Copied: .mcp.json → $TARGET/.mcp.json"
fi

# Copy feature spec template
cp "$PLUGIN_ROOT/install/docs/specs/features/TEMPLATE.md" \
   "$TARGET/docs/specs/features/TEMPLATE.md"
echo "Copied: TEMPLATE.md → $TARGET/docs/specs/features/TEMPLATE.md"

# Create empty gitkeep files for empty dirs
touch "$TARGET/docs/reports/.gitkeep"
touch "$TARGET/postman/collections/.gitkeep"
touch "$TARGET/postman/environments/.gitkeep"

echo ""
echo "Bootstrap complete."
echo ""
echo "Next steps:"
echo "  1. Install plugin:   claude plugin install $PLUGIN_ROOT"
echo "  2. Create a feature spec by copying: $TARGET/docs/specs/features/TEMPLATE.md"
echo "  3. Start pipeline:   @supervisor implement the feature spec at docs/specs/features/FEAT-001.md"
```

- [ ] **Step 2: Make bootstrap.sh executable**

```bash
chmod +x scripts/bootstrap.sh
```

- [ ] **Step 3: Check bash syntax**

```bash
bash -n scripts/bootstrap.sh && echo "Syntax OK"
```
Expected: `Syntax OK`

- [ ] **Step 4: Create `.github/copilot-instructions.md`**

```markdown
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
```

- [ ] **Step 5: Verify bootstrap.sh and copilot-instructions.md exist**

```bash
ls -la scripts/bootstrap.sh .github/copilot-instructions.md
```
Expected: both files listed, bootstrap.sh has `x` permission bit set.

- [ ] **Step 6: Commit**

```bash
git add scripts/bootstrap.sh .github/copilot-instructions.md
git commit -m "chore: add bootstrap script and Copilot IDE bridge"
```

---

## Task 14: Final Validation

**No new files. Validate the complete plugin structure.**

- [ ] **Step 1: Verify complete file count**

```bash
echo "=== .claude-plugin ===" && ls .claude-plugin/
echo "=== agents ===" && ls agents/ | wc -l
echo "=== skills ===" && ls skills/ | wc -l
echo "=== hooks ===" && ls hooks/ | wc -l
echo "=== install ===" && ls install/ && ls install/docs/specs/features/
echo "=== scripts ===" && ls scripts/
echo "=== .github ===" && ls .github/
```
Expected:
- `.claude-plugin/`: `plugin.json`
- `agents/`: 8
- `skills/`: 9
- `hooks/`: 6 (`hooks.json` + 5 scripts)
- `install/`: `settings.json .mcp.json docs/`
- `scripts/`: `bootstrap.sh`
- `.github/`: `copilot-instructions.md`

- [ ] **Step 2: Validate all JSON files**

```bash
for f in .claude-plugin/plugin.json hooks/hooks.json install/settings.json install/.mcp.json; do
  python3 -c "import json; json.load(open('$f')); print('OK: $f')"
done
```
Expected: `OK` for all 4 files.

- [ ] **Step 3: Verify all hook scripts are executable**

```bash
ls -la hooks/*.sh hooks/session-start | grep -c "^-rwx"
```
Expected: `5`

- [ ] **Step 4: Verify all agents have correct model name**

```bash
grep "model:" agents/*.md
```
Expected: all 8 agents show `model: claude-sonnet-4-6`

- [ ] **Step 5: Verify TECH-STACK DEFAULTS present in expected agents**

```bash
grep -l "TECH-STACK DEFAULTS" agents/*.md
```
Expected: `agents/developer.md  agents/gitops.md  agents/integration-tester.md  agents/test-runner.md  agents/test-writer.md`

- [ ] **Step 6: Verify all skill frontmatter names match filenames**

```bash
for f in skills/*.md; do
  name=$(grep "^name:" "$f" | sed 's/name: //')
  base=$(basename "$f" .md)
  [ "$name" = "$base" ] && echo "OK: $base" || echo "MISMATCH: $f has name '$name'"
done
```
Expected: `OK` for all 9 skills.

- [ ] **Step 7: Final commit with git log summary**

```bash
git log --oneline
```
Expected: 13 commits visible (Tasks 1-13, plus the initial design doc commit).

---

## Spec Coverage Check

| Spec requirement | Task | Status |
|---|---|---|
| 8 subagents | Tasks 3–6 | ✓ |
| 9 skills (5 from spec + 4 derived) | Tasks 7–9 | ✓ |
| 4 hook scripts | Tasks 10–11 | ✓ |
| hooks.json wiring | Task 10 | ✓ |
| session-start with platform detection | Task 10 | ✓ |
| .claude-plugin/plugin.json | Task 1 | ✓ |
| CLAUDE.md project constitution | Task 2 | ✓ |
| install/settings.json with permissions | Task 12 | ✓ |
| install/.mcp.json | Task 12 | ✓ |
| Feature spec TEMPLATE.md | Task 12 | ✓ |
| scripts/bootstrap.sh | Task 13 | ✓ |
| .github/copilot-instructions.md | Task 13 | ✓ |
| TECH-STACK DEFAULTS in build-running agents | Tasks 4–6 | ✓ |
| Model updated to claude-sonnet-4-6 | Tasks 3–6 | ✓ |
| .gitignore | Task 1 | ✓ |
