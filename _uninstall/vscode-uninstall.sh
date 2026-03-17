#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# _scripts/vscode-uninstall.sh
#
# Tears down everything vscode.sh installed:
#   1. Removes settings.json symlink
#   2. Uninstalls VSCode
#
# Usage:
#   ./_scripts/vscode-uninstall.sh
# ---------------------------------------------------------------------------

OS="$(uname -s)"

case "$OS" in
    Darwin) VSCODE_USER="$HOME/Library/Application Support/Code/User" ;;
    Linux)  VSCODE_USER="$HOME/.config/Code/User" ;;
    *)      echo "Unsupported OS: $OS"; exit 1 ;;
esac

if [ -L "$VSCODE_USER/settings.json" ]; then
    rm "$VSCODE_USER/settings.json"
    echo "Removed settings.json symlink"
fi

if command -v code &>/dev/null; then
    echo "Uninstalling VSCode..."
    case "$OS" in
        Darwin) brew uninstall --cask visual-studio-code ;;
        Linux)  sudo apt remove -y code ;;
    esac
    echo "VSCode uninstalled"
else
    echo "VSCode not installed"
fi
