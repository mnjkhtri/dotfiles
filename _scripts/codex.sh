#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# _scripts/codex.sh
#
# Sets up OpenAI Codex CLI:
#   1. Installs Node.js if not already installed
#   2. Installs Codex CLI via npm if not already installed
#
# After running, authenticate with: codex
#
# Usage:
#   ./_scripts/codex.sh
# ---------------------------------------------------------------------------

if command -v node &>/dev/null; then
    echo "Node.js already installed"
else
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo bash -
    sudo apt install -y nodejs
    echo "Node.js installed"
fi

if ! command -v npm &>/dev/null; then
    echo "Installing npm..."
    sudo apt install -y npm
    echo "npm installed"
fi

if command -v codex &>/dev/null; then
    echo "Codex CLI already installed"
else
    echo "Installing Codex CLI..."
    sudo npm install -g @openai/codex
    echo "Codex CLI installed"
fi

echo ""
echo "To authenticate:"
echo "  codex"
