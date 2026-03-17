#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# _scripts/codex.sh
#
# Sets up OpenAI Codex CLI:
#   1. Installs Node.js if not already installed
#   2. Installs Codex CLI via npm if not already installed
#   3. Symlinks config into place:
#        codex/config.toml → ~/.codex/config.toml
#
# After running, authenticate with: codex
#
# Usage:
#   ./_scripts/codex.sh
# ---------------------------------------------------------------------------

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
CODEX_DIR="$HOME/.codex"

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

# Codex depends on Node.js and npm.
step "Ensuring Node.js is installed"
if command -v node &>/dev/null; then
    done_step "Node.js already installed"
else
    step "Installing Node.js"
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo bash -
    sudo apt install -y nodejs
    done_step "installed Node.js"
fi

step "Ensuring npm is installed"
if ! command -v npm &>/dev/null; then
    step "Installing npm"
    sudo apt install -y npm
    done_step "installed npm"
else
    done_step "npm already installed"
fi

# Install the CLI after the runtime is available.
step "Ensuring Codex CLI is installed"
if command -v codex &>/dev/null; then
    done_step "Codex CLI already installed"
else
    step "Installing Codex CLI"
    sudo npm install -g @openai/codex
    done_step "installed Codex CLI"
fi

# Link tracked Codex config into the user config directory.
mkdir -p "$CODEX_DIR"
done_step "prepared Codex config directory"

if [ -f "$DOTFILES/codex/config.toml" ]; then
    step "Linking Codex config"
    link_file "$DOTFILES/codex/config.toml" "$CODEX_DIR/config.toml"
fi

echo ""
echo "To authenticate:"
echo "  codex"
