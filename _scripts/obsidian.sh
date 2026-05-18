#!/usr/bin/env bash
set -euo pipefail
DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"

echo "==> Ensuring Obsidian is installed"
if command -v obsidian &>/dev/null; then
    echo "[done] Obsidian already installed"
else
    ARCH="$(dpkg --print-architecture)"
    case "$ARCH" in
        amd64|arm64) ;;
        *)
            echo "Unsupported architecture for automatic Obsidian install: $ARCH"
            exit 1
            ;;
    esac

    echo "==> Installing Obsidian"
    LATEST_TAG="$(curl -fsSL https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | grep -o '"tag_name": "v[^"]*"' | grep -o 'v[^"]*')"
    VERSION="${LATEST_TAG#v}"
    DEB_PATH="/tmp/obsidian.deb"
    wget -qO "$DEB_PATH" "https://github.com/obsidianmd/obsidian-releases/releases/download/${LATEST_TAG}/obsidian_${VERSION}_${ARCH}.deb"
    sudo apt install -y "$DEB_PATH"
    rm -f "$DEB_PATH"
    echo "[done] installed Obsidian"
fi

if command -v gsettings &>/dev/null; then
    echo "==> Pinning Obsidian to GNOME dash"
    current_favorites="$(gsettings get org.gnome.shell favorite-apps)"
    if printf '%s\n' "$current_favorites" | grep -q "obsidian.desktop"; then
        echo "[done] obsidian already pinned to dash"
    elif [ "$current_favorites" = "[]" ]; then
        gsettings set org.gnome.shell favorite-apps "['obsidian.desktop']"
        echo "[done] pinned obsidian to GNOME dash"
    else
        gsettings set org.gnome.shell favorite-apps "${current_favorites%]}, 'obsidian.desktop']"
        echo "[done] pinned obsidian to GNOME dash"
    fi
fi

if [ "${1:-}" != "" ]; then
    VAULT_PATH="$1"
    TEMPLATE_DIR="$DOTFILES/obsidian/.obsidian"
    TARGET_DIR="$VAULT_PATH/.obsidian"

    mkdir -p "$TARGET_DIR"
    echo "[done] prepared vault config directory"

    if [ -d "$TEMPLATE_DIR" ]; then
        echo "==> Syncing Obsidian vault config"
        cp -a "$TEMPLATE_DIR/." "$TARGET_DIR/"
        echo "[done] synced vault config"
    fi

    if [ -f "$DOTFILES/obsidian/.obsidian.vimrc" ]; then
        echo "==> Syncing Obsidian vim config"
        cp -f "$DOTFILES/obsidian/.obsidian.vimrc" "$VAULT_PATH/.obsidian.vimrc"
        echo "[done] synced Obsidian vim config"
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
