#!/usr/bin/env bash
set -euo pipefail
DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
CODEX_CONFIG_DIR="${CODEX_HOME:-$HOME/.codex}"
CODEX_AGENTS_SOURCE="$DOTFILES/codex/AGENTS.md"
CODEX_CONFIG_SOURCE="$DOTFILES/codex/config.toml"
CODEX_AGENTS_TARGET="$CODEX_CONFIG_DIR/AGENTS.md"
CODEX_CONFIG_TARGET="$CODEX_CONFIG_DIR/config.toml"

link_matches() {
    local source="$1"
    local target="$2"
    [ -L "$target" ] && [ "$(readlink -f "$target")" = "$(readlink -f "$source")" ]
}

installation_matches() {
    command -v codex &>/dev/null &&
        npm list --global --depth=0 @openai/codex &>/dev/null &&
        link_matches "$CODEX_AGENTS_SOURCE" "$CODEX_AGENTS_TARGET" &&
        link_matches "$CODEX_CONFIG_SOURCE" "$CODEX_CONFIG_TARGET"
}

echo "==> Checking Codex installation and configuration"
if installation_matches; then
    echo "[done] Codex already matches the dotfiles: $(codex --version)"
else
    echo "==> Reinstalling Codex and repairing configuration"
    if ! command -v npm &>/dev/null; then
        echo "npm is required to install Codex CLI"
        exit 1
    fi

    sudo npm install --global @openai/codex
    mkdir -p "$CODEX_CONFIG_DIR"
    ln -sfnT "$CODEX_AGENTS_SOURCE" "$CODEX_AGENTS_TARGET"
    ln -sfnT "$CODEX_CONFIG_SOURCE" "$CODEX_CONFIG_TARGET"

    if ! installation_matches; then
        echo "Codex installation or configuration verification failed"
        exit 1
    fi
    echo "[done] Codex reinstalled and configuration repaired: $(codex --version)"
fi

echo ""
echo "Codex is ready: codex"
echo "Run 'codex login' if authentication is not configured yet."
