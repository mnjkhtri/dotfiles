#!/usr/bin/env bash
set -euo pipefail
DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
KITTY_CONFIG="$HOME/.config/kitty"

echo "==> Installing terminal tools"
sudo apt install -y \
    ca-certificates \
    curl \
    fonts-jetbrains-mono \
    git \
    kitty \
    tmux

echo "==> Linking tmux config"
ln -sf "$DOTFILES/tmux/tmux/.tmux.conf" "$HOME/.tmux.conf"

echo "==> Linking kitty config"
mkdir -p "$KITTY_CONFIG"
ln -sf "$DOTFILES/tmux/kitty/kitty.conf" "$KITTY_CONFIG/kitty.conf"

KITTY_THEME_DIR="$KITTY_CONFIG/themes"
KITTY_THEME_FILE="$KITTY_THEME_DIR/catppuccin-mocha.conf"

echo "==> Installing kitty theme"
mkdir -p "$KITTY_THEME_DIR"
if [ ! -f "$KITTY_THEME_FILE" ]; then
    curl -fsSL https://raw.githubusercontent.com/catppuccin/kitty/main/themes/mocha.conf -o "$KITTY_THEME_FILE"
fi

KITTY_PATH="$(command -v kitty)"

if ! update-alternatives --list x-terminal-emulator 2>/dev/null | grep -q kitty; then
    echo "==> Registering kitty as a terminal alternative"
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$KITTY_PATH" 50
fi

echo "==> Setting kitty as the default terminal"
sudo update-alternatives --set x-terminal-emulator "$KITTY_PATH"

if command -v gsettings &>/dev/null; then
    echo "==> Updating GNOME terminal preferences"
    gsettings set org.gnome.desktop.default-applications.terminal exec kitty
    gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''

    favorites="$(gsettings get org.gnome.shell favorite-apps)"
    if ! printf '%s\n' "$favorites" | grep -q "kitty.desktop"; then
        echo "==> Pinning kitty to GNOME dash"
        if [ "$favorites" = "[]" ]; then
            gsettings set org.gnome.shell favorite-apps "['kitty.desktop']"
        else
            gsettings set org.gnome.shell favorite-apps "${favorites%]}, 'kitty.desktop']"
        fi
    fi
fi

echo "[done] terminal setup complete"
