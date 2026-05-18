#!/usr/bin/env bash
set -euo pipefail
DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
OPENCODE_BIN="$HOME/.opencode/bin/opencode"
OPENCODE_DIR="$HOME/.config/opencode"
LOCAL_BIN="$HOME/.local/bin"
SYSTEM_BIN="/usr/local/bin/opencode"

echo "==> Ensuring OpenCode is installed"
if [ -x "$OPENCODE_BIN" ]; then
    echo "[done] OpenCode already installed"
else
    curl -fsSL https://opencode.ai/install | bash
    echo "[done] installed OpenCode"
fi

if [ ! -x "$OPENCODE_BIN" ]; then
    echo "OpenCode installed, but the opencode binary was not found"
    exit 1
fi

echo "==> Linking OpenCode command"
mkdir -p "$LOCAL_BIN"
ln -sf "$OPENCODE_BIN" "$LOCAL_BIN/opencode"
sudo ln -sf "$OPENCODE_BIN" "$SYSTEM_BIN"
echo "[done] linked opencode into ~/.local/bin and /usr/local/bin"

echo "==> Updating bash PATH"
touch "$HOME/.bashrc"
if grep -q 'HOME/.local/bin' "$HOME/.bashrc"; then
    echo "[done] ~/.local/bin already configured in ~/.bashrc"
else
    printf '\n# User-installed commands.\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.bashrc"
    echo "[done] added ~/.local/bin to ~/.bashrc"
fi

echo "==> Linking OpenCode config"
mkdir -p "$OPENCODE_DIR"
ln -sf "$DOTFILES/opencode/config.json" "$OPENCODE_DIR/config.json"
ln -sf "$DOTFILES/opencode/AGENTS.md" "$OPENCODE_DIR/AGENTS.md"
echo "[done] linked config.json and AGENTS.md"

echo ""
echo "OpenCode is ready: opencode"
