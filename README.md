# dotfiles

My personal development environment. Clone and run the scripts to get up and running on a fresh machine.

## Setup

```bash
sudo apt install -y git
git clone https://github.com/mnjkhtri/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 1. Git

```bash
./scripts/git.sh
gh auth login
```

### 2. Fish + Starship

```bash
./scripts/fish.sh
```

### 3. Tmux

```bash
./scripts/tmux.sh
```

### 4. VSCode

```bash
./scripts/vscode.sh
```

### 5. Claude

```bash
./scripts/claude.sh
```
