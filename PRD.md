# dotfiles — Product Requirements

Portable, reproducible macOS dev environment. One script sets up everything from scratch.

## Current Architecture

- **Bootstrap:** `install.sh` orchestrates the full setup — Homebrew, Brewfile packages, Node.js, symlinks, git identity, SSH, GitHub auth, optional tools, IDE setup
- **IDE management:** `ide.sh` (called by install.sh, also standalone) — installs Zed, writes `~/.editor_env` and `~/.gitconfig.local`
- **Symlinks:** All config files live in `~/dotfiles/` and are symlinked into place. Editor symlinks are conditional (only created if the app is installed). Definitions in `links.sh`, shared by `install.sh` and `sync.sh`
- **Sync:** `sync.sh` detects and repairs broken symlinks anytime
- **Packages:** Declarative `Brewfile` for CLI tools, terminals, fonts. Editors excluded (managed by `ide.sh`)
- **Machine-agnostic:** Checked-in configs contain no machine-specific values. `~/.gitconfig.local` (git identity + editor) and `~/.editor_env` (EDITOR/VISUAL) are generated per-machine

## Tools

| Category | Tools |
|----------|-------|
| Shell | zsh + Oh My Zsh (git, brew plugins), zsh-autosuggestions, zsh-syntax-highlighting, Forge-owned prompt |
| Terminals | Ghostty (primary), Warp (secondary, cloud-synced settings) |
| Editor | Zed — managed by `ide.sh` |
| CLI | eza, bat, fd, fzf, ripgrep, jq, yq, gh |
| Node.js | nvm (lazy-loaded) |
| Python | Docker-only, uv package manager (never on host) |
| AI agents | Claude Code (optional), Forge Code (optional, uses Ollama via built-in provider), Codex (optional, uses Ollama) |
| Notes | Obsidian (Minimal theme, shared config across vaults via symlinks), Tolaria |
| Deploy | flyctl, gcloud-cli |
| Theme | Catppuccin Mocha across all tools |

## Keybinding Scheme

### Zed — unified `cmd-opt` scheme

All panel, split, and navigation shortcuts share the `cmd-opt` prefix with mnemonic letters. No symbol keys required (ergonomic keyboard friendly).

| Shortcut | Action |
|---|---|
| `cmd-opt-t` | Toggle terminal panel (show/hide); close agent panel when in AgentPanel context |
| `cmd-opt-p` | Toggle project panel |
| `cmd-opt-g` | Toggle git panel |
| `cmd-opt-a` | Toggle agent panel |
| `cmd-opt-r` | Toggle thread history |
| `cmd-opt-v` | Split vertical |
| `cmd-opt-h` | Split horizontal |
| `cmd-opt-m` | Zoom active pane |
| `cmd-opt-arrow` | Focus adjacent pane |
| `cmd-opt-space` | Previous tab |
| `cmd-opt-tab` | Next tab |
| `ctrl-shift-w` | Close active tab |
| `cmd-n` | New agent thread (AgentPanel context only) |

`close_panel_on_toggle: true` in settings ensures panels using `ToggleFocus` close when re-triggered while focused.

### Obsidian-specific (macOS-conflict-free)

- **Daily note:** Ctrl+Shift+D
- **Left sidebar:** Cmd+Shift+E | **Right sidebar:** Ctrl+Shift+R
- **Graph view:** Ctrl+Shift+G
- **Split vertical:** Cmd+\ | **Toggle fold:** Ctrl+Cmd+.
- **Move line:** Ctrl+Cmd+Up/Down
- **Templater insert:** Ctrl+Shift+T

## Project Documentation Convention

Managed projects (scaffolded with `/project-new`) use three files:
- `ADR.md` — reverse-chronological decision log (newest first). Prepend new entries.
- `PRD.md` — living document reflecting current project state. Must stay in sync with ADR.md.
- `TASKS.md` — phases, task checklists, changelog. `TASKS.md` presence signals a managed project to AI agents.

## Templates

Five archetypes in `templates/`: `data`, `web`, `api`, `cli`, `agent`. Each ships Docker Compose, Makefile, Dockerfile, starter code. Standard targets: `make dev`, `make build`, `make test`, `make shell`, `make logs`, `make stop`.

## Skills

Claude Code skills in `config/claude/skills/`: `/project-new`, `/project-resume`, `/ship`, `/graduate`, `/learn`, `/explain`, `/slides`.
