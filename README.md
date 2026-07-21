# dotfiles

My personal Debian/Ubuntu dotfiles. Clone the repo and run the scripts you want on a fresh Linux machine.

## Setup

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

### 2. Tmux + Kitty

Installs and links:

- tmux
- kitty

```bash
./_scripts/tmux.sh
```

### 3. VS Code

```bash
./_scripts/vscode.sh
```

### 4. Codex

```bash
./_scripts/codex.sh
```
