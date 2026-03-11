#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# scripts/claude.sh
#
# Sets up Claude Code:
#   1. Installs Claude Code CLI if not already installed
#   2. Symlinks config into place:
#        claude/CLAUDE.md  → ~/.claude/CLAUDE.md   (global instructions)
#
# After running, authenticate with: claude
#
# Usage:
#   ./scripts/claude.sh
# ---------------------------------------------------------------------------

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

if command -v claude &>/dev/null; then
    echo "Claude Code already installed"
else
    echo "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
    echo "Claude Code installed"
fi

mkdir -p "$HOME/.claude"

if [ -f "$DOTFILES/claude/CLAUDE.md" ]; then
    ln -sf "$DOTFILES/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
    echo "Linked CLAUDE.md"
fi

echo ""
echo "To authenticate:"
echo "  claude"
