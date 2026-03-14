#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# scripts/vscode.sh
#
# Makes VSCode match the state defined in this repo. Every time.
#
#   1. Installs VSCode if not already installed
#   2. Syncs extensions to match vscode/extensions.txt exactly:
#   3. Symlinks config into place:
#        vscode/settings.json    → $VSCODE_USER/settings.json
#
# Usage:
#   ./scripts/vscode.sh
# ---------------------------------------------------------------------------

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
OS="$(uname -s)"

# Resolve VSCode user config path per OS
case "$OS" in
    Darwin) VSCODE_USER="$HOME/Library/Application Support/Code/User" ;;
    Linux)  VSCODE_USER="$HOME/.config/Code/User" ;;
    *)      echo "Unsupported OS: $OS"; exit 1 ;;
esac

if command -v code &>/dev/null; then
    echo "VSCode already installed"
else
    echo "Installing VSCode..."
    case "$OS" in
        Darwin)
            brew install --cask visual-studio-code
            ;;
        Linux)
            ARCH=$(dpkg --print-architecture)
            wget -qO /tmp/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-${ARCH}"
            sudo dpkg -i /tmp/vscode.deb || sudo apt install -f -y
            rm -f /tmp/vscode.deb
            ;;
    esac
    echo "VSCode installed"
fi

if [ -f "$DOTFILES/vscode/extensions.txt" ]; then
    # Read desired extensions from file (lowercase for comparison)
    desired=()
    while IFS= read -r ext; do
        [ -z "$ext" ] && continue
        [[ "$ext" == \#* ]] && continue
        desired+=("$(echo "$ext" | tr '[:upper:]' '[:lower:]')")
    done < "$DOTFILES/vscode/extensions.txt"

    # Get currently installed extensions (lowercase for comparison)
    installed=()
    while IFS= read -r ext; do
        installed+=("$(echo "$ext" | tr '[:upper:]' '[:lower:]')")
    done < <(code --list-extensions)

    # Install missing
    for ext in "${desired[@]}"; do
        if ! printf '%s\n' "${installed[@]}" | grep -qx "$ext"; then
            echo "  Installing $ext..."
            code --install-extension "$ext" --force
        fi
    done

    # Remove extras
    for ext in "${installed[@]}"; do
        if ! printf '%s\n' "${desired[@]}" | grep -qx "$ext"; then
            code --uninstall-extension "$ext" 2>/dev/null && echo "  - $ext" || echo "  ✗ $ext"
        fi
    done

    echo "Extensions synced"
fi

mkdir -p "$VSCODE_USER"
ln -sf "$DOTFILES/vscode/settings.json" "$VSCODE_USER/settings.json"
echo "Linked settings.json"
