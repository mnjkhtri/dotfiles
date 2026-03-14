#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# _scripts/fish.sh
#
# Sets up fish shell:
#   1. Installs fish if not already installed
#   2. Symlinks config into place:
#        fish/config.fish       → ~/.config/fish/config.fish
#        fish/starship.toml     → ~/.config/starship.toml
#        fish/conf.d/*.fish     → ~/.config/fish/conf.d/
#        fish/functions/*.fish  → ~/.config/fish/functions/
#   3. Optionally sets fish as default shell
#
# Usage:
#   ./scripts/fish.sh
# ---------------------------------------------------------------------------

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
FISH_CONFIG="$HOME/.config/fish"
NEEDS_RESTART=false
OS="$(uname -s)"

if command -v fish &>/dev/null; then
    echo "Fish already installed"
else
    echo "Installing fish..."
    case "$OS" in
        Darwin) brew install fish ;;
        Linux)  sudo apt install -y fish ;;
        *) echo "Unsupported OS: $OS. Install fish manually: https://fishshell.com"; exit 1 ;;
    esac
    echo "Fish installed"
    NEEDS_RESTART=true
fi

# starship (uses its own cross-platform installer)
if command -v starship &>/dev/null; then
    echo "starship already installed"
else
    echo "Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
fi

mkdir -p "$FISH_CONFIG/conf.d" "$FISH_CONFIG/functions"

ln -sf "$DOTFILES/fish/config.fish" "$FISH_CONFIG/config.fish"
echo "Linked config.fish"

mkdir -p "$HOME/.config"
ln -sf "$DOTFILES/fish/starship.toml" "$HOME/.config/starship.toml"
echo "Linked starship.toml"

if ls "$DOTFILES/fish/conf.d"/*.fish &>/dev/null 2>&1; then
    for f in "$DOTFILES/fish/conf.d"/*.fish; do
        ln -sf "$f" "$FISH_CONFIG/conf.d/$(basename "$f")"
        echo "Linked conf.d/$(basename "$f")"
    done
fi

if ls "$DOTFILES/fish/functions"/*.fish &>/dev/null 2>&1; then
    for f in "$DOTFILES/fish/functions"/*.fish; do
        ln -sf "$f" "$FISH_CONFIG/functions/$(basename "$f")"
        echo "Linked functions/$(basename "$f")"
    done
fi

FISH_PATH="$(which fish)"

case "$OS" in
    Darwin) CURRENT_SHELL=$(dscl . -read "/Users/$USER" UserShell | awk '{print $2}') ;;
    Linux)  CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7) ;;
    *)      CURRENT_SHELL="" ;;
esac

if [ "$CURRENT_SHELL" = "$FISH_PATH" ]; then
    echo "Fish already default shell"
else
    read -rp "Set fish as default shell? [y/N]: " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        grep -qxF "$FISH_PATH" /etc/shells || echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
        chsh -s "$FISH_PATH"
        NEEDS_RESTART=true
    else
        echo "Skipping — run 'chsh -s \$(which fish)' later"
    fi
fi

if [ "$NEEDS_RESTART" = true ]; then
    echo ""
    echo "=== ACTION REQUIRED ==="
    echo "Changes need a shell restart to take effect."
    echo ""
    echo "  Option 1 (recommended): Log out and back in"
    echo ""
    echo "  Option 2 (quick): Restart shell now"
    echo "    exec fish"
fi
