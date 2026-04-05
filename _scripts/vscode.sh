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
SUPPORTED_LINUX_ARCHES="amd64 arm64"

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

pin_to_gnome_dash() {
    local desktop_file="$1"

    if ! command -v gsettings &>/dev/null; then
        return
    fi

    CURRENT_FAVORITES="$(gsettings get org.gnome.shell favorite-apps)"
    if echo "$CURRENT_FAVORITES" | grep -q "$desktop_file"; then
        done_step "$(basename "$desktop_file" .desktop) already pinned to dash"
    else
        gsettings set org.gnome.shell favorite-apps \
            "$(echo "$CURRENT_FAVORITES" | sed "s/]$/, '$desktop_file']/")"
        done_step "pinned $(basename "$desktop_file" .desktop) to GNOME dash"
    fi
}

VSCODE_USER="$HOME/.config/Code/User"

# Install VS Code before syncing extensions or settings.
step "Ensuring VS Code is installed"
if command -v code &>/dev/null; then
    done_step "VS Code already installed"
else
    step "Installing VS Code"
    ARCH=$(dpkg --print-architecture)
    case "$ARCH" in
        amd64|arm64) ;;
        *)
            echo "Unsupported architecture for automatic VS Code install: $ARCH"
            echo "Supported Linux architectures: $SUPPORTED_LINUX_ARCHES"
            exit 1
            ;;
    esac
    wget -qO /tmp/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-${ARCH}"
    sudo dpkg -i /tmp/vscode.deb || sudo apt install -f -y
    rm -f /tmp/vscode.deb
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

step "Pinning VS Code to GNOME dash"
pin_to_gnome_dash "code.desktop"
