#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# _scripts/vscode.sh
#
# Makes VSCode match the state defined in this repo. Every time.
#
#   1. Installs VSCode if not already installed
#   2. Syncs extensions to match vscode/extensions.txt exactly
#   3. Symlinks config into place:
#        vscode/settings.json    → $VSCODE_USER/settings.json
#
# Usage:
#   ./_scripts/vscode.sh
# ---------------------------------------------------------------------------

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
OS="$(uname -s)"

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

# Resolve VSCode user config path per OS
case "$OS" in
    Darwin) VSCODE_USER="$HOME/Library/Application Support/Code/User" ;;
    Linux)  VSCODE_USER="$HOME/.config/Code/User" ;;
    *)      echo "Unsupported OS: $OS"; exit 1 ;;
esac

# Install VS Code before syncing extensions or settings.
step "Ensuring VS Code is installed"
if command -v code &>/dev/null; then
    done_step "VS Code already installed"
else
    step "Installing VS Code"
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
    done_step "installed VS Code"
fi

if [ -f "$DOTFILES/vscode/extensions.txt" ]; then
    step "Syncing VS Code extensions"
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
            echo "Installing $ext..."
            code --install-extension "$ext" --force
            done_step "installed $ext"
        fi
    done

    # Remove extras
    for ext in "${installed[@]}"; do
        if ! printf '%s\n' "${desired[@]}" | grep -qx "$ext"; then
            if code --uninstall-extension "$ext" 2>/dev/null; then
                done_step "removed $ext"
            fi
        fi
    done

    done_step "synced extensions"
fi

mkdir -p "$VSCODE_USER"
done_step "prepared VS Code settings directory"
step "Linking VS Code settings"
link_file "$DOTFILES/vscode/settings.json" "$VSCODE_USER/settings.json"
