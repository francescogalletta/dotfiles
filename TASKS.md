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
- [ ] Test full clean install on fresh machine

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

## Open Questions
None.
