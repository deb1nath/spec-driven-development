# Design: Agentic SDLC Plugin (Claude Code + Copilot)

**Date:** 2026-05-16  
**Status:** Approved  
**Source spec:** `0-structure.md`

---

## Problem Statement

The `0-structure.md` spec defines a complete AI-powered SDLC platform — a Supervisor agent coordinating a fleet of specialist subagents through BA → TDD → Implement → Deploy → E2E phases. This design spec covers how to scaffold that platform as a cross-platform plugin that works in Claude Code (full native support), Copilot CLI (hook-based), and Copilot IDE (bridge via custom instructions).

---

## Goals

- Scaffold all 8 agents, 9 skills, 4 hooks, and settings from `0-structure.md`
- Immediately usable in this project (open Claude Code here and start)
- Extractable and publishable as a standalone installable plugin
- Parameterized: Java/Spring Boot defaults, clearly marked override points for other stacks
- Cross-platform: Claude Code full support, Copilot CLI hook detection, Copilot IDE minimal bridge

---

## Chosen Approach: C — Dual-Layout with Install Bridge

`spec-driven-development/` IS the plugin repo. Top-level directories follow Claude Code plugin conventions (matching superpowers). An `install/` directory contains project-level files for bootstrapping target projects. A `scripts/bootstrap.sh` automates the bridge.

---

## Section 1: Repository Structure

```
spec-driven-development/
│
├── .claude-plugin/
│   └── plugin.json                ← Claude Code plugin manifest
│
├── .github/
│   └── copilot-instructions.md    ← Copilot IDE bridge (no duplication)
│
├── CLAUDE.md                      ← Project constitution (loaded by Claude Code)
│
├── agents/                        ← 8 subagent definitions
│   ├── supervisor.md
│   ├── business-analyst.md
│   ├── test-writer.md
│   ├── developer.md
│   ├── test-runner.md
│   ├── gitops.md
│   ├── integration-tester.md
│   └── reviewer.md
│
├── skills/                        ← 9 reusable skill files
│   ├── create-jira-story.md
│   ├── write-junit-tests.md
│   ├── run-test-suite.md
│   ├── implement-feature.md
│   ├── git-workflow.md
│   ├── cicd-pipeline.md
│   ├── e2e-test-browser.md
│   ├── api-test-postman.md
│   └── sdlc-report.md
│
├── hooks/
│   ├── hooks.json                 ← Claude Code hook wiring
│   ├── session-start              ← Platform detection + context injection
│   ├── pre-bash-firewall.sh       ← Blocks dangerous commands (exit 2 = hard block)
│   ├── post-edit-lint.sh          ← Auto-lints after every file write
│   ├── post-test-gate.sh          ← Blocks git commit if tests fail
│   └── subagent-audit.sh          ← Logs all agent spawns to .claude/audit.log
│
├── install/
│   ├── settings.json              ← Merged into target project's .claude/settings.json
│   ├── .mcp.json                  ← Copied to target project root
│   └── docs/
│       └── specs/features/
│           └── TEMPLATE.md        ← Feature spec template for target project
│
├── scripts/
│   └── bootstrap.sh               ← One-command target project setup
│
└── docs/
    └── superpowers/
        └── specs/
            └── 2026-05-16-agentic-sdlc-plugin-design.md   ← this file
```

---

## Section 2: Plugin Manifest & Platform Detection

### `.claude-plugin/plugin.json`

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

### `hooks/hooks.json`

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": ".*",
        "hooks": [
          { "type": "command", "command": "${CLAUDE_PLUGIN_ROOT}/hooks/session-start", "async": false }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "${CLAUDE_PLUGIN_ROOT}/hooks/pre-bash-firewall.sh", "timeout": 5 },
          { "type": "command", "command": "${CLAUDE_PLUGIN_ROOT}/hooks/post-test-gate.sh", "timeout": 120 }
        ]
      },
      {
        "matcher": "Agent",
        "hooks": [
          { "type": "command", "command": "${CLAUDE_PLUGIN_ROOT}/hooks/subagent-audit.sh", "timeout": 5 }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          { "type": "command", "command": "${CLAUDE_PLUGIN_ROOT}/hooks/post-edit-lint.sh", "timeout": 30 }
        ]
      }
    ]
  }
}
```

### `hooks/session-start` — Platform detection

Detects runtime via environment variables and emits the correct JSON format:

- `CURSOR_PLUGIN_ROOT` set → Cursor format (`additional_context`)
- `CLAUDE_PLUGIN_ROOT` set, `COPILOT_CLI` unset → Claude Code format (`hookSpecificOutput.additionalContext`)
- Otherwise (Copilot CLI sets `COPILOT_CLI=1`, or unknown) → SDK standard format (`additionalContext`)

Context injected: Supervisor invocation hint + list of loaded agents and skills.

### `.github/copilot-instructions.md` — Copilot IDE bridge

A single file pointing Copilot at the existing agents and skills structure. No content is duplicated — full definitions live in `agents/` and `skills/`. The bridge file contains:
- How to invoke the supervisor
- Agent fleet names and one-line roles
- Skill names
- Tech stack defaults and how to override them

---

## Section 3: Agent & Skill Parameterization Pattern

### Tech-stack override contract

Every agent that runs build or test commands includes a `<!-- TECH-STACK DEFAULTS -->` comment block at the top of the file. This block documents:
- Build tool (default: `./gradlew`)
- Test runner (default: `./gradlew test`)
- Lint command (default: `./gradlew checkstyleMain`)
- Language/framework (default: Java 17 / Spring Boot 3.x)
- Test libraries (default: JUnit 5 + Mockito + AssertJ)
- Source/test directory paths

**Override mechanism:** Agents are instructed to read `CLAUDE.md` first and honour the Technology Stack section. Changing the stack means updating only `CLAUDE.md` — agents adapt. The comment block serves as documentation for what options exist.

### Agents (8 total)

| Agent | Phase | Inputs | Outputs |
|---|---|---|---|
| supervisor | Orchestrator | feature spec | final-report.md |
| business-analyst | 1 | feature spec | ba-output.md |
| test-writer | 2 | spec + ba-output | test files + test-plan.md |
| developer | 3 | spec + ba-output + test-plan + tests | src files + implementation-log.md |
| test-runner | 4 | full test suite | test-results.md |
| gitops | 5 | feature branch + target | deploy-log.md |
| integration-tester | 6 | deployed URL + ACs | e2e-results.md |
| reviewer | Optional gate | git diff | review verdict (stdout) |

All agents use `claude-sonnet-4-6`. Model is declared in each agent's YAML frontmatter and can be overridden per-agent.

### Skills (9 total)

| Skill | Used by |
|---|---|
| create-jira-story | business-analyst |
| write-junit-tests | test-writer |
| run-test-suite | test-runner, developer |
| implement-feature | developer |
| git-workflow | gitops |
| cicd-pipeline | gitops |
| e2e-test-browser | integration-tester |
| api-test-postman | integration-tester |
| sdlc-report | supervisor |

### `install/settings.json`

Permissions config merged into target project's `.claude/settings.json` on bootstrap. Allows: gradlew, mvn, npm, playwright, newman, gh CLI, git operations, project scripts. Denies: `rm -rf`, force push, `git reset --hard`, writing to `.github/workflows/`, reading `.env` files.

---

## Section 4: Data Flow & Error Handling

### Pipeline data contract

```
docs/specs/features/{id}.md          ← human writes this (INPUT)
        │
        ▼
docs/reports/{id}/
  ├── ba-output.md           Phase 1 → Phase 2, 3 input
  ├── test-plan.md           Phase 2 → Phase 3 input
  ├── implementation-log.md  Phase 3 → Phase 4 input
  ├── test-results.md        Phase 4 → Gate 2 + Phase 5 input
  ├── deploy-log.md          Phase 5 → Phase 6 input
  ├── e2e-results.md         Phase 6 → final report input
  └── final-report.md        Supervisor verdict (PASS/FAIL/PARTIAL)
```

Agents never coordinate directly. Every phase reads from files written by the previous phase. The Supervisor is the only agent that reads across all phases.

### Human gates

- **Gate 1** — After Phase 1: Supervisor presents acceptance criteria and waits for explicit human approval before test-writer runs
- **Gate 2** — After Phase 4: Supervisor presents code + test results and waits for explicit human approval before gitops runs

### Retry & escalation policy

| Situation | Max retries | Escalation action |
|---|---|---|
| BA output incomplete | 2 | Ask human to clarify requirements |
| Tests don't compile | 2 | Return compiler error to Supervisor |
| Implementation fails tests | 3 | Present failure + code to human |
| CI pipeline fails | 2 | Capture CI log, present to human |
| E2E tests fail | 0 | Report only — deployment is live |

### Hook safety model

- `pre-bash-firewall.sh`: exits code 2 (hard block, cannot be bypassed by agent instructions) on patterns: `rm -rf`, `git push --force`, `git reset --hard`, `drop table`, `curl|bash`, `chmod 777`
- `post-test-gate.sh`: intercepts `git commit` commands; runs `./gradlew test --quiet`; blocks with exit 2 if tests fail
- `post-edit-lint.sh`: runs after every Write/Edit/MultiEdit; `checkstyleMain` for `.java` files, `eslint --fix` for `.ts`/`.js` files
- `subagent-audit.sh`: appends agent name + prompt preview + timestamp to `.claude/audit.log` (gitignored, local only)

---

## Bootstrap Flow

To use this plugin in a target project:

```bash
# Option 1: Install as plugin
claude plugin install /path/to/spec-driven-development

# Option 2: Bootstrap target project files
cd spec-driven-development
./scripts/bootstrap.sh /path/to/target-project

# Option 3: Work directly in this repo (plugin IS the project)
claude  # opens Claude Code here; all agents and skills are loaded
```

To run the full SDLC pipeline for a feature:

```
@supervisor implement the feature spec at docs/specs/features/FEAT-001.md
```

---

## Out of Scope (v1.0)

- JIRA MCP integration (agents fall back to markdown file output if MCP not connected)
- GitHub MCP integration (agents fall back to `gh` CLI)
- Production deployment (agents target staging only; human promotes)
- Windows hook support (hooks are bash scripts; Windows users need WSL or PowerShell equivalents)
- Multi-repo or monorepo setups

---

## Open Questions (resolved)

All open questions were resolved during brainstorming:
- **Copilot target**: Both CLI (full hooks) and IDE (minimal bridge) — resolved
- **Plugin vs project**: Dual-layout Approach C — resolved
- **Tech stack**: Parameterized with Java defaults — resolved
- **Scope**: Full spec (all 8 agents, 9 skills, 4 hooks) — resolved
- **Copilot IDE integration**: Minimal bridge (`.github/copilot-instructions.md`) — resolved
