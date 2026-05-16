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
