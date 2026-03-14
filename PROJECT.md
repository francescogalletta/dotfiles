# dotfiles

Portable, reproducible macOS dev environment.

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
- [x] Project docs (PROJECT.md, DESIGN.md)

### Phase 3: Polish ✅
- [x] README refresh after restructure
- [x] `sync.sh` — symlink doctor for drift detection/repair
- [x] Brewfile for declarative package management
- [x] Manage Cursor settings, global gitignore, zprofile
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

### 2026-02-17 (session 6)
- Moved claude/ to config/claude/ for visual consistency in repo
- Updated links.sh, README file structure and symlink table
- Symlink targets unchanged (~/.claude/* remains the same)
- Enhanced statusline to match Starship prompt: smart directory truncation, colored git branch (purple), git status indicator (red *)
- Updated README to reflect new statusline functionality
- Added ADR-007 documenting config directory organization principle

### 2026-02-16 (session 5)
- Made directory navigation aliases conditional: only create if directory exists (works across personal/work machines)
- Made Claude Code statusline portable: moved statusline.sh to repo, use $HOME instead of hardcoded username
- Added statusline.sh to links.sh for automatic symlinking
- Documented directory navigation aliases in CLAUDE.md
- Updated README with statusline.sh in file structure and symlink table

### 2026-02-16 (session 4)
- Added sync.sh and links.sh documentation to README
- Fixed project-resume skill: simplified git commands, prevent parallel tool call errors
- Added CLAUDE.md guidance: update project docs before committing, not after

### 2026-02-16 (session 2)
- Verified `project-new` and `project-resume` skills, symlinked `~/.claude/skills` and `settings.json` to dotfiles repo
- README refresh: added `claude/` directory to file structure, documented skills and settings symlinks, fixed bat link typo

### 2026-02-16
- Replaced `ai/` concatenation approach with symlinked `CLAUDE.md` at repo root
- Removed Codex CLI support (install, config, shell completions)
- Added `PROJECT.md` and `DESIGN.md` for managed project documentation
- Updated `CLAUDE.md` with session-start detection for managed projects

### 2026-02-16 (session 3)
- Added `sync.sh` — lightweight symlink doctor that detects/repairs broken links
- Extracted shared link map into `links.sh`, sourced by both `install.sh` and `sync.sh`
- Merged Ghostty config drift: theme → Selenized Light, window-decoration → auto
- Relinked `~/.config/ghostty/config` back to repo via `sync.sh`

### 2026-03-10 (session 7)
- Added `Brewfile` — declarative package manifest, replaces hardcoded list in install.sh
- Added `config/cursor/` — Cursor editor settings.json and keybindings.json (symlinked to ~/Library/Application Support/Cursor/User/)
- Added `config/git/ignore` — global gitignore (.DS_Store, .env, editor swap files)
- Added `zprofile` — managed .zprofile with brew shellenv (fixed duplicate eval)
- Updated `install.sh` to use `brew bundle install` instead of per-package loop
- Updated `links.sh` with 4 new symlinks (zprofile, git/ignore, cursor/settings, cursor/keybindings)
- Updated `gitconfig` with `core.excludesFile` pointing to managed gitignore
- Updated `test.sh` with validation for new files
- Cleaned up `.bak` artifacts from config reorganization
- Added ADR-008 (Brewfile) and ADR-009 (Cursor + gitignore)

### 2026-03-13 (session 8)
- Added Warp terminal as a second managed terminal alongside Ghostty
- Created "Transparent macOS" theme for both Ghostty and Warp (Apple HIG system colors, frosted glass effect)
- Updated Ghostty config: theme → Transparent macOS, 85% opacity with blur
- Created `config/warp/` with theme YAML and keybindings (CMD+K → command palette)
- Created `config/ghostty/themes/` with custom Ghostty theme file
- Added `cask "warp"` and `brew "yq"` to Brewfile
- Updated `links.sh` with 3 new symlinks (ghostty/themes, warp/themes, warp/keybindings)
- Added Warp account sync nudge in `install.sh` (shown when Warp is detected)
- Added Warp YAML validation to `test.sh` (theme syntax + required keys, keybindings syntax)
- Added `yq` to CI workflow
- Updated README with Warp docs, file structure, and manual settings section
- Added ADR-010 (Warp config management) and ADR-011 (Transparent macOS theme)

### 2026-03-13 (session 9)
- Added cmux terminal preferences management (plist export/import via `defaults`)
- Added cmux preferences import step to `install.sh`
- Switched Ghostty theme from Transparent macOS to catppuccin-mocha, opacity 85% → 80%
- Added Ghostty tab navigation keybindings (Alt+Shift+Left/Right)
- Updated README with cmux documentation and renumbered install steps
- Added ADR-012 (cmux plist import approach)

### 2026-03-14 (session 10)
- Added `templates/` with 5 archetypes: `data`, `web`, `api`, `cli`, `agent`
- Each template ships `docker-compose.yml`, `Makefile`, `Dockerfile`, starter code, `.env.example`, `.gitignore`, `deploy/` configs
- Updated `/project-new` skill: archetype menu, template copy step, optional `make dev` verify
- Created `/graduate` skill: platform selection (Fly.io / GCP / Railway), deploy config generation, CI/CD setup
- Created `/learn` skill: end-of-session review → proposes targeted improvements to CLAUDE.md, templates, skills
- Created `/explain` skill: explains any file, diff, or concept with trade-off table and next steps
- Added trade-off table convention and prototyping section to global `CLAUDE.md`
- Added `flyctl` and `google-cloud-sdk` to Brewfile
- Added `mkdir -p ~/projects` to `install.sh`

## Open Questions
None.
