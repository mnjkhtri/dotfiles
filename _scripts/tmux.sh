#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
FISH_CONFIG="$HOME/.config/fish"
KITTY_CONFIG="$HOME/.config/kitty"

step() {
    echo "==> $1"
}

done_step() {
    echo "[done] $1"
}

install_apt_package() {
    local cmd="$1" pkg="${2:-$1}"
    if command -v "$cmd" &>/dev/null; then
        done_step "$cmd already installed"
    else
        step "Installing $cmd"
        sudo apt install -y "$pkg"
        done_step "installed $cmd"
    fi
}

link_file() {
    ln -sf "$1" "$2"
    done_step "linked $(basename "$2")"
}

# Install terminal tooling first so the linked config works immediately.
step "Installing tmux dependencies"
install_apt_package tmux
install_apt_package xclip
link_file "$DOTFILES/tmux/tmux/.tmux.conf" "$HOME/.tmux.conf"

step "Installing fish shell"
install_apt_package fish

if ! command -v starship &>/dev/null; then
    step "Installing starship"
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
    done_step "installed starship"
else
    done_step "starship already installed"
fi

mkdir -p "$FISH_CONFIG/conf.d" "$FISH_CONFIG/functions"
done_step "prepared fish config directories"

# Link shell config after packages are available.
step "Linking fish and starship config"
link_file "$DOTFILES/tmux/fish/config.fish" "$FISH_CONFIG/config.fish"
link_file "$DOTFILES/tmux/fish/starship.toml" "$HOME/.config/starship.toml"

for f in "$DOTFILES/tmux/fish/conf.d"/*.fish; do
    [[ -e "$f" ]] && link_file "$f" "$FISH_CONFIG/conf.d/$(basename "$f")"
done

for f in "$DOTFILES/tmux/fish/functions"/*.fish; do
    [[ -e "$f" ]] && link_file "$f" "$FISH_CONFIG/functions/$(basename "$f")"
done

FISH_PATH="$(command -v fish)"
# Prompt before changing the login shell because it affects the whole user session.
step "Configuring default shell"
if [ "$(getent passwd "$USER" | cut -d: -f7)" = "$FISH_PATH" ]; then
    done_step "fish already set as default shell"
else
    read -rp "Set fish as default shell? [y/N]: " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        grep -qxF "$FISH_PATH" /etc/shells || echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
        chsh -s "$FISH_PATH"
        done_step "set fish as default shell"
    else
        echo "Skipping - run 'chsh -s \$(which fish)' later"
    fi
fi

step "Installing kitty terminal"
install_apt_package kitty

mkdir -p "$KITTY_CONFIG"
done_step "prepared kitty config directory"
link_file "$DOTFILES/tmux/kitty/kitty.conf" "$KITTY_CONFIG/kitty.conf"

KITTY_THEME_DIR="$KITTY_CONFIG/themes"
KITTY_THEME_FILE="$KITTY_THEME_DIR/catppuccin-mocha.conf"

mkdir -p "$KITTY_THEME_DIR"
if [ -f "$KITTY_THEME_FILE" ]; then
    done_step "kitty theme already installed"
else
    step "Installing kitty Catppuccin Mocha theme"
    curl -fsSL https://raw.githubusercontent.com/catppuccin/kitty/main/themes/mocha.conf -o "$KITTY_THEME_FILE"
    done_step "installed kitty theme"
fi

KITTY_PATH="$(command -v kitty)"

if ! update-alternatives --list x-terminal-emulator 2>/dev/null | grep -q kitty; then
    step "Registering kitty as a terminal alternative"
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$KITTY_PATH" 50
    done_step "registered kitty as x-terminal-emulator alternative"
fi
step "Setting kitty as the default terminal"
sudo update-alternatives --set x-terminal-emulator "$KITTY_PATH"
done_step "set kitty as default terminal"

if command -v gsettings &>/dev/null; then
    step "Updating GNOME terminal preferences"
    gsettings set org.gnome.desktop.default-applications.terminal exec kitty
    gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''
    done_step "set kitty as GNOME default terminal"

    CURRENT_FAVORITES=$(gsettings get org.gnome.shell favorite-apps)
    if echo "$CURRENT_FAVORITES" | grep -q "kitty.desktop"; then
        done_step "kitty already pinned to dash"
    else
        gsettings set org.gnome.shell favorite-apps \
            "$(echo "$CURRENT_FAVORITES" | sed "s/]$/, 'kitty.desktop']/")"
        done_step "pinned kitty to GNOME dash"
    fi
fi
