# dotfiles — Product Requirements

Portable, reproducible macOS dev environment. One script sets up everything from scratch.

## Current Architecture

- **Bootstrap:** `install.sh` orchestrates the full setup — Homebrew, Brewfile packages, Node.js, symlinks, git identity, SSH, GitHub auth, optional tools, IDE setup
- **IDE management:** `ide.sh` (called by install.sh, also standalone) — multi-select install of VS Code/Zed/Cursor, default editor picker, writes `~/.editor_env` and `~/.gitconfig.local`
- **Symlinks:** All config files live in `~/dotfiles/` and are symlinked into place. Editor symlinks are conditional (only created if the app is installed). Definitions in `links.sh`, shared by `install.sh` and `sync.sh`
- **Sync:** `sync.sh` detects and repairs broken symlinks anytime
- **Packages:** Declarative `Brewfile` for CLI tools, terminals, fonts. Editors excluded (managed by `ide.sh`)
- **Machine-agnostic:** Checked-in configs contain no machine-specific values. `~/.gitconfig.local` (git identity + editor) and `~/.editor_env` (EDITOR/VISUAL) are generated per-machine

## Tools

| Category | Tools |
|----------|-------|
| Shell | zsh + Starship prompt, zsh-autosuggestions, zsh-syntax-highlighting |
| Terminals | Ghostty (primary), Warp (secondary, cloud-synced settings) |
| Editors | Zed (primary), Cursor (optional), VS Code (optional) — managed by `ide.sh` |
| CLI | eza, bat, fd, fzf, ripgrep, jq, yq, gh |
| Node.js | nvm (lazy-loaded) |
| Python | Docker-only, uv package manager (never on host) |
| AI agents | Claude Code (optional), Forge Code (optional) |
| Deploy | flyctl, google-cloud-sdk |
| Theme | Catppuccin Mocha across all tools |

## Keybinding Scheme

Unified across Ghostty, Warp, Zed, Cursor:
- **Tab navigation:** Alt+Shift+Left/Right
- **Split panes:** Ctrl+Shift+R (right), Ctrl+Shift+D (down), Ctrl+Shift+W (close)
- **Pane focus:** Ctrl+Alt+arrow keys
- **Command palette:** Cmd+Shift+P
- **Sidebar:** Alt+Cmd+S
- **AI agent:** Cmd+I

## Project Documentation Convention

Managed projects (scaffolded with `/project-new`) use three files:
- `ADR.md` — reverse-chronological decision log (newest first). Prepend new entries.
- `PRD.md` — living document reflecting current project state. Must stay in sync with ADR.md.
- `TASKS.md` — phases, task checklists, changelog. `TASKS.md` presence signals a managed project to AI agents.

## Templates

Five archetypes in `templates/`: `data`, `web`, `api`, `cli`, `agent`. Each ships Docker Compose, Makefile, Dockerfile, starter code. Standard targets: `make dev`, `make build`, `make test`, `make shell`, `make logs`, `make stop`.

## Skills

Claude Code skills in `config/claude/skills/`: `/project-new`, `/project-resume`, `/ship`, `/graduate`, `/learn`, `/explain`, `/slides`.
