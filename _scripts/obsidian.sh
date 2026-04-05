#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# _scripts/obsidian.sh
#
# Sets up Obsidian:
#   1. Installs Obsidian if not already installed
#   2. Optionally syncs tracked vault config into a target vault:
#        obsidian/.obsidian/* → <vault>/.obsidian/
#        obsidian/.obsidian.vimrc → <vault>/.obsidian.vimrc
#
# Usage:
#   ./_scripts/obsidian.sh
#   ./_scripts/obsidian.sh /path/to/vault
# ---------------------------------------------------------------------------

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
SUPPORTED_LINUX_ARCHES="amd64 arm64"

step() {
    echo "==> $1"
}

done_step() {
    echo "[done] $1"
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

step "Ensuring Obsidian is installed"
if command -v obsidian &>/dev/null; then
    done_step "Obsidian already installed"
else
    ARCH="$(dpkg --print-architecture)"
    case "$ARCH" in
        amd64|arm64) ;;
        *)
            echo "Unsupported architecture for automatic Obsidian install: $ARCH"
    echo "Supported Linux architectures: $SUPPORTED_LINUX_ARCHES"
            exit 1
            ;;
    esac

    step "Installing Obsidian"
    LATEST_TAG="$(curl -fsSL https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | grep -o '"tag_name": "v[^"]*"' | grep -o 'v[^"]*')"
    VERSION="${LATEST_TAG#v}"
    DEB_PATH="/tmp/obsidian.deb"
    wget -qO "$DEB_PATH" "https://github.com/obsidianmd/obsidian-releases/releases/download/${LATEST_TAG}/obsidian_${VERSION}_${ARCH}.deb"
    sudo apt install -y "$DEB_PATH"
    rm -f "$DEB_PATH"
    done_step "installed Obsidian"
fi

step "Pinning Obsidian to GNOME dash"
pin_to_gnome_dash "obsidian.desktop"

if [ "${1:-}" != "" ]; then
    VAULT_PATH="$1"
    TEMPLATE_DIR="$DOTFILES/obsidian/.obsidian"
    TARGET_DIR="$VAULT_PATH/.obsidian"

    mkdir -p "$TARGET_DIR"
    done_step "prepared vault config directory"

    if [ -d "$TEMPLATE_DIR" ]; then
        step "Syncing Obsidian vault config"
        cp -a "$TEMPLATE_DIR/." "$TARGET_DIR/"
        done_step "synced vault config"
    fi

    if [ -f "$DOTFILES/obsidian/.obsidian.vimrc" ]; then
        step "Syncing Obsidian vim config"
        cp -f "$DOTFILES/obsidian/.obsidian.vimrc" "$VAULT_PATH/.obsidian.vimrc"
        done_step "synced Obsidian vim config"
    fi

    if [ -f "$TARGET_DIR/community-plugins.json" ]; then
        echo ""
        echo "Manual step required:"
        echo "  Open Obsidian -> Settings -> Community plugins"
        echo "  Turn off Restricted Mode"
        echo "  Install these plugins:"
        python3 - "$TARGET_DIR/community-plugins.json" <<'PYTHON'
import json
import sys
from pathlib import Path

plugins = json.loads(Path(sys.argv[1]).read_text())
for plugin in plugins:
    print(f"    - {plugin}")
PYTHON
    fi
else
    echo ""
    echo "To sync the tracked vault config into a vault:"
    echo "  ./_scripts/obsidian.sh /path/to/vault"
fi
