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
