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
