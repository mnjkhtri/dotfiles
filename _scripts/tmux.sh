#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
FISH_CONFIG="$HOME/.config/fish"

install_if_missing() {
    local cmd="$1" pkg="${2:-$1}"
    if command -v "$cmd" &>/dev/null; then
        echo "$cmd already installed"
    else
        echo "Installing $cmd..."
        sudo apt install -y "$pkg"
        echo "$cmd installed"
    fi
}

link() {
    ln -sf "$1" "$2"
    echo "Linked $(basename "$2")"
}

install_if_missing tmux
install_if_missing xclip

link "$DOTFILES/tmux/tmux/.tmux.conf" "$HOME/.tmux.conf"

install_if_missing fish

if ! command -v starship &>/dev/null; then
    echo "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
else
    echo "starship already installed"
fi

mkdir -p "$FISH_CONFIG/conf.d" "$FISH_CONFIG/functions"

link "$DOTFILES/tmux/fish/config.fish" "$FISH_CONFIG/config.fish"
link "$DOTFILES/tmux/fish/starship.toml" "$HOME/.config/starship.toml"

for f in "$DOTFILES/tmux/fish/conf.d"/*.fish; do
    [[ -e "$f" ]] && link "$f" "$FISH_CONFIG/conf.d/$(basename "$f")"
done

for f in "$DOTFILES/tmux/fish/functions"/*.fish; do
    [[ -e "$f" ]] && link "$f" "$FISH_CONFIG/functions/$(basename "$f")"
done

FISH_PATH="$(which fish)"
if [ "$(getent passwd "$USER" | cut -d: -f7)" = "$FISH_PATH" ]; then
    echo "fish already default shell"
else
    read -rp "Set fish as default shell? [y/N]: " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        grep -qxF "$FISH_PATH" /etc/shells || echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
        chsh -s "$FISH_PATH"
    else
        echo "Skipping — run 'chsh -s \$(which fish)' later"
    fi
fi

install_if_missing kitty

mkdir -p "$HOME/.config/kitty"
link "$DOTFILES/tmux/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

KITTY_THEME_DIR="$HOME/.config/kitty/themes"
KITTY_THEME_FILE="$KITTY_THEME_DIR/catppuccin-mocha.conf"

mkdir -p "$KITTY_THEME_DIR"
if [ -f "$KITTY_THEME_FILE" ]; then
    echo "kitty theme already installed"
else
    echo "Installing kitty Catppuccin Mocha theme..."
    curl -fsSL https://raw.githubusercontent.com/catppuccin/kitty/main/themes/mocha.conf -o "$KITTY_THEME_FILE"
    echo "kitty theme installed"
fi

KITTY_PATH="$(command -v kitty)"

if ! update-alternatives --list x-terminal-emulator 2>/dev/null | grep -q kitty; then
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$KITTY_PATH" 50
    echo "Registered kitty as x-terminal-emulator alternative"
fi
sudo update-alternatives --set x-terminal-emulator "$KITTY_PATH"
echo "Set kitty as default terminal"

if command -v gsettings &>/dev/null; then
    gsettings set org.gnome.desktop.default-applications.terminal exec kitty
    gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''
    echo "Set kitty as GNOME default terminal"

    CURRENT_FAVORITES=$(gsettings get org.gnome.shell favorite-apps)
    if echo "$CURRENT_FAVORITES" | grep -q "kitty.desktop"; then
        echo "kitty already pinned to dash"
    else
        gsettings set org.gnome.shell favorite-apps \
            "$(echo "$CURRENT_FAVORITES" | sed "s/]$/, 'kitty.desktop']/")"
        echo "Pinned kitty to GNOME dash"
    fi
fi
