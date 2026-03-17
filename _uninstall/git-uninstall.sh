#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# _scripts/git-uninstall.sh
#
# Tears down everything git.sh installed:
#   1. Removes .gitconfig and .gitignore_global symlinks
#   2. Uninstalls gh CLI
#
# Usage:
#   ./_scripts/git-uninstall.sh
# ---------------------------------------------------------------------------

OS="$(uname -s)"

for link in "$HOME/.gitconfig" "$HOME/.gitignore_global"; do
    if [ -L "$link" ]; then
        rm "$link"
        echo "Removed $link symlink"
    fi
done

if command -v gh &>/dev/null; then
    echo "Uninstalling gh..."
    case "$OS" in
        Darwin) brew uninstall gh ;;
        Linux)  sudo apt remove -y gh ;;
        *) echo "Unsupported OS: $OS — remove gh manually" ;;
    esac
    echo "gh uninstalled"
else
    echo "gh not installed"
fi
