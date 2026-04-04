# dotfiles

My personal Linux development environment. Clone the repo and run the scripts to get up and running on a fresh machine.

## Setup

Tested for Debian/Ubuntu-style systems with `apt`.

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

## Claude Code

Tracked config for Claude, Codex, and OpenCode now lives under:

- `claude-code/claude/`
- `claude-code/codex/`
- `claude-code/opencode/`

Install and link all AI tools with:

```bash
./_scripts/claude-code.sh
```

You can also target specific tools:

```bash
./_scripts/claude-code.sh claude
```

This script:

- installs Claude Code, Codex, and OpenCode if needed
- links tracked config from `claude-code/`
- prompts you to choose a tool if you run it with no arguments
