# dotfiles

Portable, reproducible dev environment for macOS. One script sets up everything from scratch.

## What's included

| Tool | Purpose |
|------|---------|
| [Homebrew](https://brew.sh) | macOS package manager |
| [Ghostty](https://ghostty.org) | GPU-accelerated terminal emulator |
| [AeroSpace](https://nikitabobko.github.io/AeroSpace/) | i3-like tiling window manager (config + cheatsheet in `config/aerospace/`) |
| [JankyBorders](https://github.com/FelixKratz/JankyBorders) | Highlights the focused window; launched by AeroSpace |
| [Warp](https://www.warp.dev) | AI-powered terminal with IDE features |
| [Oh My Zsh](https://ohmyz.sh) | Zsh framework with plugins (`git`, `brew`, autosuggestions, syntax highlighting) |
| [eza](https://eza.rocks) | Modern replacement for `ls` with icons and colors |
| [bat](https://github.com/sharkdp/bat) | `cat` with syntax highlighting and line numbers |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder — Ctrl+R history search, file search |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast recursive code search (`rg`) |
| [jq](https://jqlang.github.io/jq/) | Command-line JSON processor |
| [yq](https://github.com/mikefarah/yq) | Command-line YAML processor |
| [gh](https://cli.github.com) | GitHub CLI — PRs, issues, auth from the terminal |
| [nvm](https://github.com/nvm-sh/nvm) | Node.js version manager |
| [Obsidian](https://obsidian.md) | Markdown-based note-taking (app only; its config stays local to each vault) |
| [Tolaria](https://tolaria.md) | Markdown knowledgebase manager |

### Optional (prompted during install)

| Tool | Purpose |
|------|---------|
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | Anthropic's AI coding agent |
| [Google Drive](https://www.google.com/drive/download/) | Desktop sync client |

### Editor

[Zed](https://zed.dev) — GPU-accelerated native editor, installed and configured by `ide.sh`.

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
3. Installs all packages from `Brewfile` via `brew bundle` (CLI tools + Ghostty + Warp + AeroSpace + JankyBorders + Ollama + Obsidian + Tolaria)
4. Installs Node.js LTS via nvm
5. Installs Oh My Zsh, symlinks Homebrew plugins into `$ZSH_CUSTOM/plugins/`
6. Symlinks config files (zshrc, zprofile, gitconfig, git/ignore, ghostty, warp/themes, warp/keybindings, zed, CLAUDE.md, Claude skills/hooks/statusline)
7. Prompts for git name/email
8. Generates an ed25519 SSH key
9. Authenticates with GitHub via `gh auth login`
10. Prompts for optional installs (Claude Code, Google Drive)
11. Runs `ide.sh` to install and configure editors
12. Creates `~/projects/` directory

Doesn't replace any configuration already in place.

Failures capture the last 5 lines of output so you can see what broke without digging through logs.

## Other scripts

### `ide.sh` — Editor installer

Installs Zed and writes `~/.editor_env` (sourced by zshrc) and `~/.gitconfig.local` (included by gitconfig). Called automatically by `install.sh`, but can also be run standalone.

```bash
cd ~/dotfiles
./ide.sh        # run standalone to reinstall or reset editor config
```

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

### `links.map` + `links.sh` — Symlink definitions

The mapping of repo files to their target locations lives in `links.map`: OS-neutral data, one pipe-delimited row per managed config (source | label | guard | macOS destination | Windows destination). Edit this file to add or remove symlinks. `links.sh` is the macOS driver that parses the map into the `LINKS` array consumed by `install.sh` and `sync.sh`; the future `windows/links.ps1` will read the same map. The `zed` guard skips rows when Zed isn't installed.

## File structure

```
~/dotfiles/
├── install.sh                  # Bootstrap script
├── ide.sh                      # Editor installer (Zed)
├── Brewfile                    # Homebrew package manifest (used by install.sh)
├── README.md
├── CLAUDE.md                   # Claude Code global config → ~/CLAUDE.md
├── ADR.md                      # Architecture decision records (newest first)
├── PRD.md                      # Current project state (synced with ADR.md)
├── TASKS.md                    # Phases, progress, changelog
├── zshrc                       # Zsh config → ~/.zshrc
├── zprofile                    # Zsh profile → ~/.zprofile
├── gitconfig                   # Git config → ~/.gitconfig
└── config/                     # Configs for each tooling
    ├── aerospace/
    │   ├── aerospace.toml      # AeroSpace config → ~/.aerospace.toml
    │   └── CHEATSHEET.md       # Keybinding reference
    ├── claude/
    │   ├── statusline.sh       # Claude Code statusline → ~/.claude/statusline.sh
    │   ├── hooks/              # Claude Code hooks → ~/.claude/hooks/
    │   │   └── session-start.sh #  SessionStart briefing for managed projects (TASKS.md)
    │   └── skills/             # Claude Code skills → ~/.claude/skills/
    │       ├── ship/           #   /ship — commit and push
    │       └── learn/          #   /learn — end-of-session review and improvement loop
    ├── zed/
    │   ├── settings.json       # Zed settings → ~/.config/zed/settings.json
    │   ├── keymap.json         # Zed keybindings → ~/.config/zed/keymap.json
    │   └── tasks.json          # Zed tasks → ~/.config/zed/tasks.json
    ├── ghostty/
    │   ├── config              # Ghostty config → ~/.config/ghostty/config
    │   └── themes/             # Custom themes → ~/.config/ghostty/themes/
    ├── git/
    │   └── ignore              # Global gitignore → ~/.config/git/ignore
    ├── raycast/
    │   └── scripts/            # Raycast Script Commands (directory registered in Raycast, not symlinked)
    │       ├── show-shortcuts.sh      # Cheatsheet for the frontmost app, or for an app / term you type
    │       ├── aerospace-shortcuts.sh #   Titled wrapper so root search matches "aerospace"
    │       └── cca.sh                 # Claude agent view in a new Ghostty window (calls `cca` from zshrc)
    ├── voyager/
    │   ├── pull-layout.sh      # Snapshot ZSA Voyager layout from Oryx into git
    │   ├── layout.json         # Versioned layout snapshot (edit in Oryx, then re-pull)
    │   └── README.md           # Kontroll usage + WIN layer spec for the Windows machine
    └── warp/
        ├── keybindings.yaml    # Warp keybindings → ~/.warp/keybindings.yaml
        └── themes/             # Custom themes → ~/.warp/themes/
            └── Catppuccin Mocha.yaml
```

### Unified keybindings

Keybindings are aligned across all tools where the action exists. The scheme is defined once, implemented per-tool:

| Action | Shortcut | Ghostty | Warp | Zed |
|--------|----------|---------|------|-----|
| Command palette | `Cmd+Shift+P` | yes | yes | yes |
| Previous tab | `Alt+Shift+Left` | yes | yes | yes |
| Next tab | `Alt+Shift+Right` | yes | yes | yes |
| Split right | `Ctrl+Shift+R` | yes | -- | yes |
| Split down | `Ctrl+Shift+D` | yes | -- | yes |
| Close pane | `Ctrl+Shift+W` | yes | -- | yes |
| Focus left pane | `Ctrl+Alt+Left` | yes | -- | yes |
| Focus right pane | `Ctrl+Alt+Right` | yes | -- | yes |
| Focus up pane | `Ctrl+Alt+Up` | yes | -- | yes |
| Focus down pane | `Ctrl+Alt+Down` | yes | -- | yes |
| Toggle sidebar | `Alt+Cmd+S` | -- | -- | yes |
| AI agent | `Cmd+I` | -- | -- | yes |
| Duplicate line | `Cmd+Shift+D` | -- | -- | yes |
| Build | `Cmd+Shift+B` | -- | -- | yes |
| Test | `Cmd+Shift+T` | -- | -- | yes |

Warp doesn't support split panes, so those bindings are terminal-only (Ghostty) and editor-only (Zed).

### Raycast cheatsheets

Two Script Commands surface keybindings without leaving Raycast:

| Command | Argument | Shows |
|---|---|---|
| `AeroSpace Shortcuts` | — | The AeroSpace cheatsheet. Worth a global hotkey. |
| `Show Shortcuts` | none | Cheatsheet for the frontmost app |
| `Show Shortcuts` | `aerospace`, `aero` | That sheet, by name or unique prefix |
| `Show Shortcuts` | `workspace`, `resize` | Matching lines from every sheet, grouped |
| `CCA` | none | Claude Code agent view in a new Ghostty window, opened at `$HOME` |
| `CCA` | `save-the-date`, `dotfiles` | Same, opened in that project (path or zoxide query) |

`CCA` calls the `cca` shell function from `zshrc`, so the permission mode and the zoxide lookup are defined in one place. `DEFAULT_DIR` at the top of `cca.sh` sets where it lands with no argument.

Sheets are discovered, not registered: any `config/<tool>/CHEATSHEET.md`, plus anything in `config/raycast/shortcuts/*.md` for tools with no config directory of their own. Drop a file in either place and it shows up. AeroSpace's sheet is read in place from `config/aerospace/CHEATSHEET.md`, so `aerospace.toml` stays the source of truth with one file in between.

Raycast renders Script Command output as plain text with ANSI colour and no markdown, so the script flattens the tables into aligned columns itself.

**One-time setup, and it cannot be scripted:** Raycast, Settings, Extensions, Script Commands, Add Directories, point it at `~/dotfiles/config/raycast/scripts`. Raycast holds that path in its own settings store, so there is no file for `install.sh` to write. Assign the hotkey there too.

Raycast itself is installed but deliberately **not** in the Brewfile: its cask times out on Cloudflare R2 and blocks `brew bundle` (ADR-019). Same treatment as `gcloud-cli`. The scripts are inert without it.

### Warp settings

Warp settings (font, opacity, theme selection) sync via your Warp account. Log in after install to restore them. The custom theme and keybindings are managed as dotfiles and symlinked into `~/.warp/`.

### AI agent config

Claude Code's instructions, scripts and skills live in this repo and are symlinked to their expected location:

| Repo path | Symlink target | Purpose |
|-----------|---------------|---------|
| `CLAUDE.md` | `~/CLAUDE.md` | Global instructions (tone, tools, conventions) |
| `config/claude/statusline.sh` | `~/.claude/statusline.sh` | Statusline script (directory, git branch, git status) |
| `config/claude/hooks/` | `~/.claude/hooks/` | Hook scripts (SessionStart briefing for managed projects) |
| `config/claude/skills/` | `~/.claude/skills/` | Slash commands (`/ship`, `/learn`) |

Edits flow both ways -- change the live file or the repo file, same result.

**`~/.claude/settings.json` is not in the repo.** Claude Code, `/config`, plugin installs and org tooling all rewrite it, which kept breaking the symlink and writing machine-specific values back into git (ADR-046). Each machine owns its file: set it up with `/config` and `/permissions` in Claude Code, or edit it directly. The hooks and statusline above only run once that file points at them.

**Model choice is deliberately not in `settings.json`.** A `/model` change writes to it, and the model differs per machine anyway. The default lives in `~/.zshrc.local` (machine-local, sourced by `zshrc`, never committed):

```bash
export ANTHROPIC_MODEL="opus[1m]"   # opus[1m] | claude-fable-5[1m] | sonnet | haiku
```

Environment beats settings files, so this wins. For one session only, use `/model` and press `s` instead of Enter.

## Pending decisions

Ideas discussed but deliberately not adopted yet. Revisit when the itch returns; delete the entry when decided either way.

### AeroSpace: float windows that tile badly (2026-08-15)

Utility windows (System Settings, Finder popups, Keymapp) get squashed into tiny tiles when tiled. Per-app rules would make them float by default:

```toml
[[on-window-detected]]
if.app-id = 'com.apple.systempreferences'
run = 'layout floating'
```

- **Doing it:** those windows open at their natural size and stop disrupting the layout. Cost: per-app rule list to maintain, and behavior becomes app-dependent.
- **Not doing it:** everything behaves uniformly; the escape hatch is manual — `alt-shift-semicolon` then `f` floats the focused window on demand.
- **Status:** holding off until tiled utility windows actually annoy in practice.

### AeroSpace: pin apps to workspaces (2026-08-15)

`on-window-detected` rules can auto-move apps to fixed workspaces (Chrome → 1, Zed → 2, Ghostty → 3), turning numbered workspaces into named places:

```toml
[[on-window-detected]]
if.app-id = 'com.google.Chrome'
run = 'move-node-to-workspace 1'
```

- **Doing it:** `alt-1..5` becomes reflexive because each number always means the same thing; the biggest single boost to workspace muscle memory.
- **Not doing it:** full freedom to compose ad-hoc per-workflow workspaces (e.g. browser + terminal together for one task) without fighting auto-placement rules.
- **Status:** deferred — want to keep mixing windows freely per workflow while learning; reconsider once usage patterns settle.

