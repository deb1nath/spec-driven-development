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
