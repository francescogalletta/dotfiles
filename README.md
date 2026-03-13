# dotfiles

Portable, reproducible dev environment for macOS. One script sets up everything from scratch.

## What's included

| Tool | Purpose |
|------|---------|
| [Homebrew](https://brew.sh) | macOS package manager |
| [Ghostty](https://ghostty.org) | GPU-accelerated terminal emulator |
| [Warp](https://www.warp.dev) | AI-powered terminal with IDE features |
| [Starship](https://starship.rs) | Fast, customizable cross-shell prompt |
| [eza](https://eza.rocks) | Modern replacement for `ls` with icons and colors |
| [bat](https://github.com/sharkdp/bat) | `cat` with syntax highlighting and line numbers |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder — Ctrl+R history search, file search |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast recursive code search (`rg`) |
| [jq](https://jqlang.github.io/jq/) | Command-line JSON processor |
| [yq](https://github.com/mikefarah/yq) | Command-line YAML processor |
| [gh](https://cli.github.com) | GitHub CLI — PRs, issues, auth from the terminal |
| [nvm](https://github.com/nvm-sh/nvm) | Node.js version manager |
| [uv](https://docs.astral.sh/uv/) | Fast Python package and project manager |

### Optional (prompted during install)

| Tool | Purpose |
|------|---------|
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | Anthropic's AI coding agent |
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

1. Listing all install steps
2. Installs Homebrew
3. Installs all packages from `Brewfile` via `brew bundle` (CLI tools + Ghostty + Warp)
4. Installs Node.js LTS via nvm
5. Installs Python via uv
6. Symlinks config files (zshrc, zprofile, gitconfig, git/ignore, ghostty, ghostty/themes, starship, warp/themes, warp/keybindings, cursor, CLAUDE.md, Claude skills/settings/statusline)
7. Prompts for git name/email
8. Generates an ed25519 SSH key
9. Authenticates with GitHub via `gh auth login`
10. Prompts for optional installs (Claude Code, Google Drive)

Doesn't replace any configuration already in place.

Failures capture the last 5 lines of output so you can see what broke without digging through logs.

## Other scripts

### `sync.sh` — Symlink doctor

Detects and repairs broken or missing symlinks. Run this if:
- An app overwrites a symlinked config with a regular file (Ghostty does this on config reset)
- You manually deleted a symlink and want to restore it
- You want to verify all dotfiles are properly linked

```bash
cd ~/dotfiles
./sync.sh
```

Output shows which links are OK (✓) and which were fixed or created (🔗). Existing files are backed up to `*.bak` before relinking.

### `links.sh` — Symlink definitions

Shared configuration sourced by both `install.sh` and `sync.sh`. Defines the mapping of repo files to their target locations. Not meant to be run directly — edit this file to add or remove symlinks.

## File structure

```
~/dotfiles/
├── install.sh                  # Bootstrap script
├── Brewfile                    # Homebrew package manifest (used by install.sh)
├── README.md
├── CLAUDE.md                   # Claude Code global config → ~/CLAUDE.md
├── PROJECT.md                  # [Meta], this project's phases and planning
├── DESIGN.md                   # [Meta] Architecture decision records
├── zshrc                       # Zsh config → ~/.zshrc
├── zprofile                    # Zsh profile → ~/.zprofile
├── gitconfig                   # Git config → ~/.gitconfig
└── config/                     # Configs for each tooling
    ├── claude/
    │   ├── settings.json       # Claude Code settings → ~/.claude/settings.json
    │   ├── statusline.sh       # Claude Code statusline (matches Starship prompt) → ~/.claude/statusline.sh
    │   └── skills/             # Claude Code skills → ~/.claude/skills/
    │       ├── project-new/    #   /project-new — scaffold a new project
    │       ├── project-resume/ #   /project-resume — resume an existing project
    │       └── ship/           #   /ship — commit and push
    ├── cursor/
    │   ├── settings.json       # Cursor settings → ~/Library/.../Cursor/User/settings.json
    │   └── keybindings.json    # Cursor keybindings → ~/Library/.../Cursor/User/keybindings.json
    ├── ghostty/
    │   ├── config              # Ghostty config → ~/.config/ghostty/config
    │   └── themes/             # Custom themes → ~/.config/ghostty/themes/
    │       └── Transparent macOS
    ├── git/
    │   └── ignore              # Global gitignore → ~/.config/git/ignore
    ├── starship.toml           # Starship prompt → ~/.config/starship.toml
    └── warp/
        ├── keybindings.yaml    # Warp keybindings → ~/.warp/keybindings.yaml
        └── themes/             # Custom themes → ~/.warp/themes/
            └── Transparent macOS.yaml
```

### Warp settings

Warp settings (font, opacity, theme selection) sync via your Warp account. Log in after install to restore them. The custom theme and keybindings are managed as dotfiles and symlinked into `~/.warp/`.

### AI agent config

All Claude Code config lives in this repo and is symlinked to its expected location:

| Repo path | Symlink target | Purpose |
|-----------|---------------|---------|
| `CLAUDE.md` | `~/CLAUDE.md` | Global instructions (tone, tools, conventions) |
| `config/claude/settings.json` | `~/.claude/settings.json` | Permissions, statusline command |
| `config/claude/statusline.sh` | `~/.claude/statusline.sh` | Statusline script (directory, git branch, git status) |
| `config/claude/skills/` | `~/.claude/skills/` | Slash commands (`/project-new`, `/project-resume`) |

Edits flow both ways — change the live file or the repo file, same result. Adding support for another AI agent means adding another config file and symlink.
