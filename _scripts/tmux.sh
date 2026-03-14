#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# _scripts/tmux.sh
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
OS="$(uname -s)"

if command -v tmux &>/dev/null; then
    echo "Tmux already installed"
else
    echo "Installing tmux..."
    case "$OS" in
        Darwin) brew install tmux ;;
        Linux)  sudo apt install -y tmux ;;
        *) echo "Unsupported OS: $OS. Install tmux manually: https://github.com/tmux/tmux"; exit 1 ;;
    esac
    echo "Tmux installed"
fi

# xclip is Linux-only; macOS has pbcopy/pbpaste natively
if [ "$OS" = "Linux" ]; then
    if command -v xclip &>/dev/null; then
        echo "xclip already installed"
    else
        echo "Installing xclip..."
        sudo apt install -y xclip
        echo "xclip installed"
    fi
fi

ln -sf "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
echo "Linked .tmux.conf"
