# dotfiles — Tasks & Progress

## Phases

### Phase 1: Core Setup ✅
- [x] Install script (Homebrew, CLI tools, Ghostty, nvm, uv)
- [x] Shell config (zshrc, aliases, completions)
- [x] Git config (gitconfig, SSH key, gh auth)
- [x] Terminal config (Ghostty, Starship)

### Phase 2: AI Tooling ✅
- [x] Claude Code optional install
- [x] Global CLAUDE.md with environment prefs
- [x] Simplify AI config: symlink approach, remove Codex
- [x] Claude skills: project-new, project-resume
- [x] Project docs (ADR.md, PRD.md, TASKS.md)

### Phase 3: Polish ✅
- [x] README refresh after restructure
- [x] `sync.sh` — symlink doctor for drift detection/repair
- [x] Brewfile for declarative package management
- [x] Manage editor settings, global gitignore, zprofile
- [x] Clean up `.bak` artifacts from config reorg
- [x] ~~Test full clean install on fresh machine~~ (dropped: no fresh machine available, testing in-place instead)

### Phase 4: Prototyping Fast-Path ✅
- [x] Project templates: `data`, `web`, `api`, `cli`, `agent` archetypes
- [x] Updated `/project-new` — archetype selection + template copy
- [x] New skill `/graduate` — deploy to Fly.io or GCP Cloud Run
- [x] New skill `/learn` — end-of-session self-improvement loop
- [x] New skill `/explain` — educational mode with trade-off tables
- [x] `CLAUDE.md` — trade-off table convention + prototyping section
- [x] Brewfile — added `flyctl` and `google-cloud-sdk`
- [x] `install.sh` — creates `~/projects/` on fresh install

## Changelog

### 2026-02-16 (session 1)
- Replaced `ai/` concatenation approach with symlinked `CLAUDE.md` at repo root
- Removed Codex CLI support (install, config, shell completions)
- Added `PROJECT.md` and `DESIGN.md` for managed project documentation
- Updated `CLAUDE.md` with session-start detection for managed projects

### 2026-02-16 (session 2)
- Verified `project-new` and `project-resume` skills, symlinked `~/.claude/skills` and `settings.json` to dotfiles repo
- README refresh: added `claude/` directory to file structure, documented skills and settings symlinks, fixed bat link typo

### 2026-02-16 (session 3)
- Added `sync.sh` — lightweight symlink doctor that detects/repairs broken links
- Extracted shared link map into `links.sh`, sourced by both `install.sh` and `sync.sh`
- Merged Ghostty config drift: theme → Selenized Light, window-decoration → auto
- Relinked `~/.config/ghostty/config` back to repo via `sync.sh`

### 2026-02-16 (session 4)
- Added sync.sh and links.sh documentation to README
- Fixed project-resume skill: simplified git commands, prevent parallel tool call errors
- Added CLAUDE.md guidance: update project docs before committing, not after

### 2026-02-16 (session 5)
- Made directory navigation aliases conditional: only create if directory exists (works across personal/work machines)
- Made Claude Code statusline portable: moved statusline.sh to repo, use $HOME instead of hardcoded username
- Added statusline.sh to links.sh for automatic symlinking
- Documented directory navigation aliases in CLAUDE.md
- Updated README with statusline.sh in file structure and symlink table

### 2026-02-17 (session 6)
- Moved claude/ to config/claude/ for visual consistency in repo
- Updated links.sh, README file structure and symlink table
- Enhanced statusline to match Starship prompt
- Added ADR-007 documenting config directory organization principle

### 2026-03-10 (session 7)
- Added `Brewfile` — declarative package manifest
- Added `config/cursor/` — Cursor editor settings.json and keybindings.json
- Added `config/git/ignore` — global gitignore
- Added `zprofile` — managed .zprofile with brew shellenv
- Updated `install.sh` to use `brew bundle install`
- Cleaned up `.bak` artifacts
- Added ADR-008, ADR-009

### 2026-03-13 (session 8)
- Added Warp terminal as a second managed terminal alongside Ghostty
- Created themes for Ghostty and Warp
- Added `config/warp/` with theme YAML and keybindings
- Added ADR-010, ADR-011

### 2026-03-13 (session 9)
- Added cmux terminal preferences (later removed in session 12)
- Switched Ghostty theme to catppuccin-mocha, opacity 85% → 80%
- Added Ghostty tab navigation keybindings
- Added ADR-012

### 2026-03-14 (session 10)
- Added `templates/` with 5 archetypes
- Created skills: `/graduate`, `/learn`, `/explain`
- Added trade-off table convention to CLAUDE.md
- Added `flyctl` and `google-cloud-sdk` to Brewfile
- Added ADR-013

### 2026-03-27 (session 11)
- Explored terminal email via himalaya — reverted, too convoluted
- No net changes to dotfiles

### 2026-04-09 (session 12)
- Simplified to Cursor-primary workflow: removed cmux, Midnight Commander, micro
- Unified on Catppuccin Mocha theme across all tools
- Migrated Python templates from pip to uv
- Added ADR-014, ADR-015

### 2026-04-14–16 (session 13)
- Added Zed editor config (`config/zed/`)
- Created `ide.sh` — standalone IDE installer with multi-select and default picker
- Switched primary editor from Cursor to Zed
- Made editor symlinks conditional (only if app installed)
- Moved git `[user]` to `~/.gitconfig.local` for machine-agnosticity
- Aligned keybindings across all tools (unified table in README)
- Architecture review: fixed step numbering, dead code, stale references, test.sh issues
- Migrated doc convention: DESIGN.md → ADR.md (reverse-chronological), PROJECT.md → TASKS.md, created PRD.md
- Added fd to Brewfile, removed dead bun config, empty ghostty/themes, property-management template
- Meta-analysis: updated CLAUDE.md with lessons learned
- Added ADR-016, ADR-017

### Phase 5: Notes & Launcher Integration ✅
- [x] Obsidian shared config (appearance, app, plugins, hotkeys)
- [x] Dynamic vault discovery in links.sh via jq
- [x] Documentation updates (README, ADR, PRD, TASKS)
- [ ] Test Google Drive symlink persistence over time

## Changelog

### 2026-05-03 (session 18)
- Fixed OMZ plugin symlinks: individual `.zsh` files with `.plugin.zsh` suffix instead of symlinking Homebrew `share/` dirs
- Fixed Codex config: top-level `model`/`model_provider` keys, removed dead `[model_providers.ollama-launch]` block
- Simplified Forge config to `[session]` only; added `forge provider login ollama` step to `install.sh`
- Changed Zed terminal font to `JetBrainsMono Nerd Font Mono` for icon support
- Verified Codex and Forge both route to local Ollama with `gemma4`
- Added ADR-022

### 2026-05-02 (session 17)
- Replaced Starship with Oh My Zsh as shell framework
- Rewrote `zshrc`: OMZ block with `plugins=(git brew zsh-autosuggestions zsh-syntax-highlighting)`, `ZSH_THEME=""` so Forge owns prompt, history after source, `add-zsh-hook` for bell, Forge block last
- Added OMZ install step to `install.sh` with `KEEP_ZSHRC=yes RUNZSH=no CHSH=no` + Homebrew plugin symlinks
- Removed `brew "starship"` from Brewfile, starship symlink from `links.sh`, starship test from `test.sh`
- Deleted `config/starship.toml`
- Updated README, PRD, ADR (ADR-021), TASKS

### 2026-05-02 (session 16)
- Added Codex CLI as optional install (`brew install --cask codex`)
- Created `config/codex/config.toml` with Ollama provider and `gemma4` default model
- Symlink in `links.sh` conditional on `codex` being in PATH
- Updated README, PRD, ADR (ADR-020), TASKS

### 2026-05-02 (session 15)
- Removed Raycast from Brewfile and `config/raycast/` — cask times out on Cloudflare R2 during install
- Removed Cursor and VS Code from `ide.sh` and `links.sh` — Zed-only setup
- Deleted `config/cursor/` from repo
- Added Tolaria cask to Brewfile
- Renamed deprecated casks: `docker` → `docker-desktop`, `google-cloud-sdk` → `gcloud-cli`
- Brew bundle now streams filtered output live (`--line-buffered` grep, `-u` sed)
- Added ADR-019

### 2026-05-02 (session 14)
- Unified Obsidian config across vaults: Minimal theme, starter hotkeys, community plugins
- Created `config/obsidian/shared/` with 5 shared config files symlinked into each vault
- Dynamic vault discovery in `links.sh` via `jq` parsing of `obsidian.json`
- Added Raycast to Brewfile and `install.sh` macOS defaults
- Created Raycast Script Command (`show-shortcuts.sh`) for per-app shortcut display
- Created per-app shortcut reference files in `config/raycast/shortcuts/`
- Updated README with Obsidian column in keybindings table, Obsidian config section, Raycast section
- Added ADR-018

## Open Questions
None.
