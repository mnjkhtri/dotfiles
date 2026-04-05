# dotfiles

My personal development environment setup. Clone the repo and run the scripts to get up and running on a fresh machine.

## Setup

This repo is primarily built around Debian/Ubuntu-style Linux systems with `apt`.

### Linux

```bash
sudo apt update
sudo apt install -y git curl wget
git clone https://github.com/mnjkhtri/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### macOS

Homebrew is required for the macOS-supported scripts (`git`, `claude-code`, and `obsidian`).

```bash
command -v brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git
git clone https://github.com/mnjkhtri/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

## Platform Support

Support is based on the current script behavior.

| Script | Linux `amd64` | Linux `arm64` | macOS |
| --- | --- | --- | --- |
| `_scripts/git.sh` | ✅ | ✅ | ✅ |
| `_scripts/tmux.sh` | ✅ | ✅ | ❌ |
| `_scripts/vscode.sh` | ✅ | ✅ | ❌ |
| `_scripts/claude-code.sh` | ✅ | ✅ | ✅ |
| `_scripts/obsidian.sh` | ✅ | ✅ | ✅ |

`Linux` here means Debian/Ubuntu-style systems with `apt`; `✅` means supported and `❌` means not supported.

## Install

### 1. Git

```bash
./_scripts/git.sh
gh auth login
```

### 2. Shell + Tmux + Kitty

Installs and links:

- fish
- starship
- tmux
- kitty

```bash
./_scripts/tmux.sh
```

### 3. VS Code

```bash
./_scripts/vscode.sh
```

### 4. Claude Code / Codex / OpenCode

```bash
./_scripts/claude-code.sh
```

If you use both Claude Code and Codex, you can also add the official Codex plugin inside Claude Code:

```text
/plugin marketplace add openai/codex-plugin-cc
/plugin install codex@openai-codex
/reload-plugins
/codex:setup
```

### 5. Obsidian

```bash
./_scripts/obsidian.sh
```
