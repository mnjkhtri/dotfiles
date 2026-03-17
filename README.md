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

### 4. Claude

```bash
./_scripts/claude.sh
```

### 5. Codex

```bash
./_scripts/codex.sh
```
