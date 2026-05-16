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
