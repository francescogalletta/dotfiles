# dotfiles

Portable, reproducible dev environment for macOS. One script sets up everything from scratch.

## What's included

| Tool | Purpose |
|------|---------|
| [Homebrew](https://brew.sh) | macOS package manager |
| [Starship](https://starship.rs) | Fast, customizable cross-shell prompt |
| [eza](https://eza.rocks) | Modern replacement for `ls` with icons and colors |
| [bat](https://github.com/sharkdp/bat) | `cat` with syntax highlighting and line numbers |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder — Ctrl+R history search, file search |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast recursive code search (`rg`) |
| [jq](https://jqlang.github.io/jq/) | Command-line JSON processor |
| [gh](https://cli.github.com) | GitHub CLI — PRs, issues, auth from the terminal |
| [nvm](https://github.com/nvm-sh/nvm) | Node.js version manager |
| [uv](https://docs.astral.sh/uv/) | Fast Python package and project manager |
| [Ghostty](https://ghostty.org) | GPU-accelerated terminal emulator |

## Prerequisites

- macOS (Apple Silicon)
- [Ghostty](https://ghostty.org) installed
- Internet connection

## Install on a new machine

```bash
git clone git@github.com:<your-username>/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The script is idempotent — safe to run multiple times. Existing config files are backed up to `*.bak` before being replaced.

## What `install.sh` does

1. Installs Homebrew (if missing)
2. Installs all tools via `brew install` (skips already-installed)
3. Installs Node.js LTS via nvm (if missing)
4. Installs Python via uv (if missing)
5. Symlinks config files (backs up existing ones)
6. Prompts for git name/email (if not configured)
7. Generates an ed25519 SSH key (if none exists)
8. Authenticates with GitHub via `gh auth login` (if needed)

## File structure

```
~/dotfiles/
├── install.sh                  # Bootstrap script
├── README.md                   # This file
├── zshrc                       # Zsh config → ~/.zshrc
├── gitconfig                   # Git config → ~/.gitconfig
└── config/
    ├── ghostty/
    │   └── config              # Ghostty config → ~/.config/ghostty/config
    └── starship.toml           # Starship prompt → ~/.config/starship.toml
```

## Manual post-install steps

- Install a [Nerd Font](https://www.nerdfonts.com/) (e.g. JetBrains Mono) for icons in eza and starship
- Open a new Ghostty window to load the new shell config
- Verify: `node --version`, `python3 --version`, `gh auth status`
