# dotfiles

My personal development environment setup. Clone the repo and run the scripts to get up and running on a fresh machine.

## Setup

This repo is primarily built around Debian/Ubuntu-style Linux systems with `apt`.

## Platform Support

Support is based on the current script behavior.

| Script | Linux `amd64` | Linux `arm64` | macOS |
| --- | --- | --- | --- |
| `_scripts/git.sh` | ✅ | ✅ | ✅ |
| `_scripts/tmux.sh` | ✅ | ✅ | ❌ |
| `_scripts/vscode.sh` | ✅ | ✅ | ❌ |
| `_scripts/claude-code.sh` | ✅ | ✅ | ❌ |
| `_scripts/obsidian.sh` | ✅ | ✅ | ✅ |

`Linux` here means Debian/Ubuntu-style systems with `apt`; `✅` means supported and `❌` means not supported.

```bash
sudo apt update
sudo apt install -y git curl wget
git clone https://github.com/mnjkhtri/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

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

### 5. Obsidian

```bash
./_scripts/obsidian.sh
```
