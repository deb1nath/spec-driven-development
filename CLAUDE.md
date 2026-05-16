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
