#!/usr/bin/env bash
# Bootstraps a target project with the agentic-sdlc plugin files
# Usage: ./scripts/bootstrap.sh /path/to/your/target-project
#
# After running this script, install the plugin in your target project:
#   claude plugin install /path/to/spec-driven-development

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
