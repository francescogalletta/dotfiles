# dotfiles

Portable, reproducible dev environment for macOS. One script sets up everything from scratch.

## What's included

| Tool | Purpose |
|------|---------|
| [Homebrew](https://brew.sh) | macOS package manager |
| [Ghostty](https://ghostty.org) | GPU-accelerated terminal emulator |
| [Starship](https://starship.rs) | Fast, customizable cross-shell prompt |
| [eza](https://eza.rocks) | Modern replacement for `ls` with icons and colors |
| [bat](https://github.com/sharkdup/bat) | `cat` with syntax highlighting and line numbers |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder — Ctrl+R history search, file search |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast recursive code search (`rg`) |
| [jq](https://jqlang.github.io/jq/) | Command-line JSON processor |
| [gh](https://cli.github.com) | GitHub CLI — PRs, issues, auth from the terminal |
| [nvm](https://github.com/nvm-sh/nvm) | Node.js version manager |
| [uv](https://docs.astral.sh/uv/) | Fast Python package and project manager |

### Optional (prompted during install)

| Tool | Purpose |
|------|---------|
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | Anthropic's AI coding agent |
| [Codex CLI](https://github.com/openai/codex) | OpenAI's AI coding agent |
| [Google Drive](https://www.google.com/drive/download/) | Desktop sync client |

## Prerequisites

- macOS (Apple Silicon)
- Internet connection

## Install on a new machine

```bash
git clone git@github.com:francescogalletta/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The script is idempotent — safe to run multiple times. Existing config files are backed up to `*.bak` before being replaced.

## What `install.sh` does

1. Prints a welcome banner listing all install steps
2. Installs Homebrew (if missing)
3. Installs all CLI tools via `brew install` (skips already-installed)
4. Installs Ghostty via `brew install --cask`
5. Installs Node.js LTS via nvm
6. Installs Python via uv
7. Symlinks config files (zshrc, gitconfig, ghostty, starship)
8. Prompts for git name/email (if not configured)
9. Generates an ed25519 SSH key (if none exists)
10. Authenticates with GitHub via `gh auth login`
11. Prompts for optional installs (Claude Code, Codex CLI, Google Drive)

Progress is shown with an animated spinner and progress bar. Failures capture the last 5 lines of output so you can see what broke without digging through logs.

## File structure

```
~/dotfiles/
├── install.sh                  # Bootstrap script
├── README.md                   # This file
├── zshrc                       # Zsh config → ~/.zshrc
├── gitconfig                   # Git config → ~/.gitconfig
├── ai/                         # AI coding tool configs (shared source of truth)
│   ├── common.md               # Environment prefs shared by all AI tools
│   ├── claude.md               # Claude Code header
│   └── codex.md                # Codex CLI header
└── config/
    ├── ghostty/
    │   └── config              # Ghostty config → ~/.config/ghostty/config
    └── starship.toml           # Starship prompt → ~/.config/starship.toml
```

### Why `ai/`?

Both Claude Code and Codex CLI read markdown files to learn your environment preferences (CLI aliases, preferred tools, runtime managers, etc.). Rather than maintaining two copies that drift apart, `ai/common.md` holds the shared preferences and each tool gets a short header file (`claude.md`, `codex.md`).

During install, the script assembles them:
- `~/CLAUDE.md` = `ai/claude.md` + `ai/common.md`
- `~/.codex/AGENTS.md` = `ai/codex.md` + `ai/common.md`

Edit `common.md` once, re-run install, and both tools stay in sync.

## Post-install

- Open a new Ghostty window to load the new shell config
- Verify: `node --version`, `python3 --version`, `gh auth status`
