#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# scripts/tmux.sh
#
# Sets up tmux:
#   1. Installs tmux if not already installed
#   2. Symlinks config into place:
#        tmux/.tmux.conf → ~/.tmux.conf
#
# Usage:
#   ./scripts/tmux.sh
# ---------------------------------------------------------------------------

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

if command -v tmux &>/dev/null; then
    echo "Tmux already installed"
else
    echo "Installing tmux..."
    sudo apt install -y tmux
    echo "Tmux installed"
fi

if command -v xclip &>/dev/null; then
    echo "xclip already installed"
else
    echo "Installing xclip..."
    sudo apt install -y xclip
    echo "xclip installed"
fi

ln -sf "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
echo "Linked .tmux.conf"
