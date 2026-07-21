#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
LOCAL="$HOME/.gitconfig.local"

current_name=$(git config -f "$LOCAL" user.name 2>/dev/null || echo "")
current_email=$(git config -f "$LOCAL" user.email 2>/dev/null || echo "")
echo "==> Configuring git identity"
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
echo "[done] saved identity to $LOCAL"
echo "==> Ensuring GitHub CLI is installed"
if command -v gh &>/dev/null; then
    echo "[done] gh already installed"
else
    echo "==> Installing gh"
    sudo apt install -y gh
    echo "[done] installed gh"
fi
echo "ACTION: run 'gh auth login' to authenticate with GitHub"
echo "==> Linking git config files"
ln -sf "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
echo "[done] linked .gitconfig"
ln -sf "$DOTFILES/git/.gitignore_global" "$HOME/.gitignore_global"
echo "[done] linked .gitignore_global"
