# dotfiles

My personal development environment. Clone and run the scripts to get up and running on a fresh machine.

## Setup

### macOS

```bash
# Install Homebrew (includes git and Xcode CLT)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

git clone https://github.com/mnjkhtri/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### Linux

```bash
sudo apt install -y git
git clone https://github.com/mnjkhtri/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

---

### 1. Git

```bash
./_scripts/git.sh
gh auth login
```

### 2. Fish + Starship

```bash
./_scripts/fish.sh
```

### 3. Tmux

```bash
./_scripts/tmux.sh
```

### 4. VSCode

```bash
./_scripts/vscode.sh
```

### 5. Claude

```bash
./_scripts/claude.sh
```
