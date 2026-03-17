#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# _scripts/git.sh
#
# Sets up git configuration:
#   1. Asks for your name and email (hit enter to keep current value)
#   2. Writes them into ~/.gitconfig.local
#   3. Symlinks into home directory:
#        git/.gitconfig        → ~/.gitconfig
#        git/.gitignore_global → ~/.gitignore_global
#
# Usage:
#   ./_scripts/git.sh
# ---------------------------------------------------------------------------

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
LOCAL="$HOME/.gitconfig.local"
OS="$(uname -s)"

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

current_name=$(git config -f "$LOCAL" user.name 2>/dev/null || echo "")
current_email=$(git config -f "$LOCAL" user.email 2>/dev/null || echo "")

# Prompt for git identity and persist it to the local include file.
step "Configuring git identity"
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
done_step "saved identity to $LOCAL"

# GitHub CLI (for auth — password auth not supported by GitHub)
step "Ensuring GitHub CLI is installed"
if command -v gh &>/dev/null; then
    done_step "gh already installed"
else
    step "Installing gh"
    case "$OS" in
        Darwin) brew install gh ;;
        Linux)  sudo apt install -y gh ;;
        *) echo "Unsupported OS: $OS. Install gh manually: https://cli.github.com"; exit 1 ;;
    esac
    done_step "installed gh"
fi
echo "ACTION: run 'gh auth login' to authenticate with GitHub"

# Link tracked git config into the home directory.
step "Linking git config files"
link_file "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES/git/.gitignore_global" "$HOME/.gitignore_global"
