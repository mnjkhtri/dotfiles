#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# _scripts/claude-code.sh
#
# Sets up AI tools:
#   1. Lets you choose Claude, Codex, OpenCode, or all
#   2. Installs selected tools if not already installed
#   3. Symlinks tracked config into place for the selected tools:
#        claude-code/claude/CLAUDE.md      → ~/.claude/CLAUDE.md
#        claude-code/claude/settings.json  → ~/.claude/settings.json
#        claude-code/codex/config.toml     → ~/.codex/config.toml
#        claude-code/opencode/config.json  → ~/.config/opencode/config.json
#
# Usage:
#   ./_scripts/claude-code.sh
#   ./_scripts/claude-code.sh claude
#   ./_scripts/claude-code.sh codex opencode
#   ./_scripts/claude-code.sh all
# ---------------------------------------------------------------------------

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
OS="$(uname -s)"
CLAUDE_DIR="$HOME/.claude"
CODEX_DIR="$HOME/.codex"
OPENCODE_DIR="$HOME/.config/opencode"

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

require_supported_os() {
    case "$OS" in
        Linux) ;;
        *)
            echo "Unsupported OS: $OS"
            exit 1
            ;;
    esac
}

ensure_node_and_npm() {
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
    if command -v npm &>/dev/null; then
        done_step "npm already installed"
    else
        step "Installing npm"
        sudo apt install -y npm
        done_step "installed npm"
    fi
}

install_claude() {
    step "Ensuring Claude Code is installed"
    if command -v claude &>/dev/null; then
        done_step "Claude Code already installed"
    else
        step "Installing Claude Code"
        curl -fsSL https://claude.ai/install.sh | bash
        done_step "installed Claude Code"
    fi

    mkdir -p "$CLAUDE_DIR"
    done_step "prepared Claude config directory"

    if [ -f "$DOTFILES/claude-code/claude/CLAUDE.md" ]; then
        step "Linking Claude instructions"
        link_file "$DOTFILES/claude-code/claude/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
    fi

    if [ -f "$DOTFILES/claude-code/claude/settings.json" ]; then
        step "Linking Claude settings"
        link_file "$DOTFILES/claude-code/claude/settings.json" "$CLAUDE_DIR/settings.json"
    fi
}

install_codex() {
    ensure_node_and_npm

    step "Ensuring Codex CLI is installed"
    if command -v codex &>/dev/null; then
        done_step "Codex CLI already installed"
    else
        step "Installing Codex CLI"
        sudo npm install -g @openai/codex
        done_step "installed Codex CLI"
    fi

    mkdir -p "$CODEX_DIR"
    done_step "prepared Codex config directory"

    if [ -f "$DOTFILES/claude-code/codex/config.toml" ]; then
        step "Linking Codex config"
        link_file "$DOTFILES/claude-code/codex/config.toml" "$CODEX_DIR/config.toml"
    fi
}

install_opencode() {
    ensure_node_and_npm

    step "Ensuring OpenCode is installed"
    if command -v opencode &>/dev/null; then
        done_step "OpenCode already installed"
    else
        step "Installing OpenCode"
        curl -fsSL https://opencode.ai/install | bash
        done_step "installed OpenCode"
    fi

    mkdir -p "$OPENCODE_DIR"
    done_step "prepared OpenCode config directory"

    if [ -f "$DOTFILES/claude-code/opencode/config.json" ]; then
        step "Linking OpenCode config"
        link_file "$DOTFILES/claude-code/opencode/config.json" "$OPENCODE_DIR/config.json"
    fi
}

print_auth_instructions() {
    echo ""
    echo "To authenticate:"
    if [ "${INSTALL_CLAUDE:-0}" -eq 1 ]; then
        echo "  claude"
    fi
    if [ "${INSTALL_CODEX:-0}" -eq 1 ]; then
        echo "  codex"
    fi
    if [ "${INSTALL_OPENCODE:-0}" -eq 1 ]; then
        echo "  opencode"
    fi
}

INSTALL_CLAUDE=0
INSTALL_CODEX=0
INSTALL_OPENCODE=0

require_supported_os

if [ "$#" -eq 0 ]; then
    echo "Choose what to install:"
    echo "  1) claude"
    echo "  2) codex"
    echo "  3) opencode"
    echo "  4) all"
    read -r -p "Selection: " selection

    case "$selection" in
        1|claude)
            INSTALL_CLAUDE=1
            ;;
        2|codex)
            INSTALL_CODEX=1
            ;;
        3|opencode)
            INSTALL_OPENCODE=1
            ;;
        4|all)
            INSTALL_CLAUDE=1
            INSTALL_CODEX=1
            INSTALL_OPENCODE=1
            ;;
        *)
            echo "Invalid selection: $selection"
            exit 1
            ;;
    esac
else
    for tool in "$@"; do
        case "$tool" in
            claude)
                INSTALL_CLAUDE=1
                ;;
            codex)
                INSTALL_CODEX=1
                ;;
            opencode)
                INSTALL_OPENCODE=1
                ;;
            all)
                INSTALL_CLAUDE=1
                INSTALL_CODEX=1
                INSTALL_OPENCODE=1
                ;;
            *)
                echo "Unknown tool: $tool"
                echo "Use one or more of: claude codex opencode all"
                exit 1
                ;;
        esac
    done
fi

if [ "$INSTALL_CLAUDE" -eq 1 ]; then
    install_claude
fi

if [ "$INSTALL_CODEX" -eq 1 ]; then
    install_codex
fi

if [ "$INSTALL_OPENCODE" -eq 1 ]; then
    install_opencode
fi

print_auth_instructions
