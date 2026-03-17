#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# _scripts/codex-uninstall.sh
#
# Tears down everything codex.sh installed:
#   1. Uninstalls Codex CLI
#   (Node.js/npm are left in place — likely used by other tools)
#
# Usage:
#   ./_scripts/codex-uninstall.sh
# ---------------------------------------------------------------------------

if command -v codex &>/dev/null; then
    echo "Uninstalling Codex CLI..."
    sudo npm uninstall -g @openai/codex
    echo "Codex CLI uninstalled"
else
    echo "Codex CLI not installed"
fi
