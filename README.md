# dotfiles

My personal development environment setup. Clone the repo and run the scripts to get up and running on a fresh machine.

## Setup

This repo is primarily built around Debian/Ubuntu-style Linux systems with `apt`.

## Platform Support

Support is based on the current script behavior.

| Script | Linux `amd64` | Linux `arm64` | macOS | Clear Reject |
| --- | --- | --- | --- | --- |
| `_scripts/git.sh` | Supported | Supported | Supported | Rejects other OSes |
| `_scripts/tmux.sh` | Supported | Supported | Not supported | macOS is not handled by the script |
| `_scripts/vscode.sh` | Supported | Supported | Not supported | Rejects Linux architectures outside `amd64` and `arm64` |
| `_scripts/claude-code.sh` | Supported | Supported | Not supported | Rejects all non-Linux OSes |
| `_scripts/obsidian.sh` | Supported | Supported | Supported | Rejects other OSes and rejects Linux architectures outside `amd64` and `arm64` |

Notes:

- `Linux` here means Debian/Ubuntu-style systems with `apt`.
- When a script uses `apt` but does not check architecture explicitly, the README treats both Linux `amd64` and Linux `arm64` as supported by script logic.
- `Not supported` means the script does not provide a macOS path.
- `Clear Reject` means the script explicitly exits for that OS or architecture.

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

Supported: Linux `amd64`, Linux `arm64`.
Not supported: macOS.

```bash
./_scripts/tmux.sh
```

### 3. VS Code

Supported: Linux `amd64`, Linux `arm64`.
Clear reject: Linux architectures outside `amd64` and `arm64`, and macOS.

```bash
./_scripts/vscode.sh
```

### 4. Claude Code / Codex / OpenCode

Supported: Linux `amd64`, Linux `arm64`.
Clear reject: macOS and other non-Linux OSes.

```bash
./_scripts/claude-code.sh
```

### 5. Obsidian

Supported: Linux `amd64`, Linux `arm64`, and macOS.
Clear reject: Linux architectures outside `amd64` and `arm64`, and other non-Linux OSes.

```bash
./_scripts/obsidian.sh
```
