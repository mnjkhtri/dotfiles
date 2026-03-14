#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# _scripts/git.sh
#
# Sets up git configuration:
#   1. Asks for your name and email (hit enter to keep current value)
#   2. Writes them into git/.gitconfig
#   3. Symlinks into home directory:
#        git/.gitconfig        → ~/.gitconfig
#        git/.gitignore_global → ~/.gitignore_global
#
# Usage:
#   ./scripts/git.sh
# ---------------------------------------------------------------------------

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
LOCAL="$HOME/.gitconfig.local"
OS="$(uname -s)"

current_name=$(git config -f "$LOCAL" user.name 2>/dev/null || echo "")
current_email=$(git config -f "$LOCAL" user.email 2>/dev/null || echo "")

if [ -n "$current_name" ]; then
    read -rp "Git name [$current_name]: " name
    name="${name:-$current_name}"
else
    read -rp "Git name: " name
fi
[ -z "$name" ] && echo "Name cannot be empty." && exit 1

if [ -n "$current_email" ]; then
    read -rp "Git email [$current_email]: " email
    email="${email:-$current_email}"
else
    read -rp "Git email: " email
fi
[ -z "$email" ] && echo "Email cannot be empty." && exit 1

git config -f "$LOCAL" user.name "$name"
git config -f "$LOCAL" user.email "$email"
echo "Saved identity to ~/.gitconfig.local"

# GitHub CLI (for auth — password auth not supported by GitHub)
if command -v gh &>/dev/null; then
    echo "gh already installed"
else
    echo "Installing gh..."
    case "$OS" in
        Darwin) brew install gh ;;
        Linux)  sudo apt install -y gh ;;
        *) echo "Unsupported OS: $OS. Install gh manually: https://cli.github.com"; exit 1 ;;
    esac
fi
echo "ACTION: run 'gh auth login' to authenticate with GitHub"

ln -sf "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES/git/.gitignore_global" "$HOME/.gitignore_global"
echo "Linked .gitconfig and .gitignore_global"
