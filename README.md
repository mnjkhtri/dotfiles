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

Installs the official Codex CLI package and links the managed configuration
from this repository into `~/.codex`:

- `codex/config.toml` → `~/.codex/config.toml`
- `codex/AGENTS.md` → `~/.codex/AGENTS.md`

```bash
./_scripts/codex.sh
```

The installer is convergent. It does nothing when the official global npm
package is installed and both configuration links match. If either the
installation or configuration differs, it reinstalls Codex and repairs both
links.

Authenticate after the first installation:

```bash
codex login
codex login status
```

The managed defaults use workspace-only writes, on-request approvals, cached
web search, and no outbound network access for sandboxed shell commands.
Project-level overrides can be placed in a trusted repository at
`.codex/config.toml`.
