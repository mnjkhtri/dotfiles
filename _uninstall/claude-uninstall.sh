#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# _scripts/claude-uninstall.sh
#
# Tears down everything claude.sh installed:
#   1. Removes CLAUDE.md symlink
#   2. Uninstalls Claude Code CLI
#
# Usage:
#   ./_scripts/claude-uninstall.sh
# ---------------------------------------------------------------------------

# Remove symlink
if [ -L "$HOME/.claude/CLAUDE.md" ]; then
    rm "$HOME/.claude/CLAUDE.md"
    echo "Removed ~/.claude/CLAUDE.md symlink"
fi

# Uninstall Claude Code CLI
if command -v claude &>/dev/null; then
    echo "Uninstalling Claude Code..."
    npm uninstall -g @anthropic-ai/claude-code 2>/dev/null \
        || npm uninstall -g claude 2>/dev/null \
        || { echo "Could not uninstall via npm — remove manually"; }
    echo "Claude Code uninstalled"
else
    echo "Claude Code not installed"
fi
