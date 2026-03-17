#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# _scripts/tmux-uninstall.sh
#
# Tears down everything tmux.sh installed:
#   1. Removes all config symlinks (tmux, fish, starship, kitty)
#   2. Reverts default shell away from fish (to bash)
#   3. Uninstalls kitty, starship, fish, xclip, tmux
#
# Usage:
#   ./_scripts/tmux-uninstall.sh
# ---------------------------------------------------------------------------

FISH_CONFIG="$HOME/.config/fish"

# --- symlinks ---------------------------------------------------------------

for link in \
    "$HOME/.tmux.conf" \
    "$FISH_CONFIG/config.fish" \
    "$HOME/.config/starship.toml" \
    "$HOME/.config/kitty/kitty.conf"
do
    if [ -L "$link" ]; then
        rm "$link"
        echo "Removed $link"
    fi
done

for dir in conf.d functions; do
    for link in "$FISH_CONFIG/$dir"/*.fish; do
        [ -L "$link" ] && rm "$link" && echo "Removed $link"
    done
done

# --- default shell ----------------------------------------------------------

FISH_PATH="$(command -v fish 2>/dev/null || true)"
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)

if [ -n "$FISH_PATH" ] && [ "$CURRENT_SHELL" = "$FISH_PATH" ]; then
    read -rp "Revert default shell to bash? [y/N]: " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        chsh -s "$(command -v bash)"
        echo "Default shell reverted to bash"
    fi
fi

# --- kill running sessions --------------------------------------------------

if command -v tmux &>/dev/null; then
    if tmux list-sessions &>/dev/null 2>&1; then
        echo "Killing tmux server..."
        tmux kill-server
    fi
fi

# Kill any fish processes (this script runs in bash, so it's safe to do)
if pgrep -x fish &>/dev/null; then
    echo "Killing fish processes..."
    pkill -x fish || true
fi

# --- packages ---------------------------------------------------------------

if command -v kitty &>/dev/null; then
    echo "Uninstalling kitty..."
    sudo apt remove -y kitty
fi

if command -v starship &>/dev/null; then
    echo "Uninstalling starship..."
    sudo rm -f /usr/local/bin/starship
fi

if command -v fish &>/dev/null; then
    echo "Uninstalling fish..."
    sudo apt remove -y fish
fi

if command -v xclip &>/dev/null; then
    echo "Uninstalling xclip..."
    sudo apt remove -y xclip
fi

if command -v tmux &>/dev/null; then
    echo "Uninstalling tmux..."
    sudo apt remove -y tmux
fi

echo "Done"
