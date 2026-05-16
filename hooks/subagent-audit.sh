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
