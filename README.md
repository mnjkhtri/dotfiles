# dotfiles

My personal development environment setup. Clone the repo and run the scripts to get up and running on a fresh machine.

## Setup

This repo is primarily built around Debian/Ubuntu-style Linux systems with `apt`.

## Platform Support

Tested:

- Linux: Debian/Ubuntu-style systems with `apt`
- Linux architectures: `amd64`, `arm64` where the installer explicitly checks arch
- macOS: supported for `git` and `obsidian`

Current script support:

- `_scripts/git.sh`: Linux and macOS
- `_scripts/tmux.sh`: Linux only
- `_scripts/vscode.sh`: Linux only, `amd64` and `arm64`
- `_scripts/claude-code.sh`: Linux only
- `_scripts/obsidian.sh`: Linux and macOS, with Linux auto-install on `amd64` and `arm64`

If a script does not mention macOS support, assume Linux is the target.

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

Linux only.

```bash
./_scripts/tmux.sh
```

### 3. VS Code

Linux only. Automatic install currently supports `amd64` and `arm64`.

```bash
./_scripts/vscode.sh
```

### 4. Claude Code / Codex / OpenCode

Linux only.

```bash
./_scripts/claude-code.sh
```

### 5. Obsidian

Linux and macOS. Linux automatic install currently supports `amd64` and `arm64`.

```bash
./_scripts/obsidian.sh
```
