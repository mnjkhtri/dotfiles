#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# _scripts/claude.sh
#
# Sets up Claude Code:
#   1. Installs Claude Code CLI if not already installed
#   2. Symlinks config into place:
#        claude/CLAUDE.md  → ~/.claude/CLAUDE.md   (global instructions)
#
# After running, authenticate with: claude
#
# Usage:
#   ./_scripts/claude.sh
# ---------------------------------------------------------------------------

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"

step() {
    echo "==> $1"
}

done_step() {
    echo "[done] $1"
}

link_file() {
    ln -sf "$1" "$2"
    done_step "linked $(basename "$2")"
}

# Install Claude CLI before linking its global config.
step "Ensuring Claude Code is installed"
if command -v claude &>/dev/null; then
    done_step "Claude Code already installed"
else
    step "Installing Claude Code"
    curl -fsSL https://claude.ai/install.sh | bash
    done_step "installed Claude Code"
fi

mkdir -p "$CLAUDE_DIR"
done_step "prepared Claude config directory"

if [ -f "$DOTFILES/claude/CLAUDE.md" ]; then
    # Link global instructions if they are present in the repo.
    step "Linking Claude instructions"
    link_file "$DOTFILES/claude/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
fi

if [ -f "$DOTFILES/claude/settings.json" ]; then
    step "Linking Claude settings"
    link_file "$DOTFILES/claude/settings.json" "$CLAUDE_DIR/settings.json"
fi

echo ""
echo "To authenticate:"
echo "  claude"
