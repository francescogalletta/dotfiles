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

### Phase 3: Polish ← current
- [x] README refresh after restructure
- [x] `sync.sh` — symlink doctor for drift detection/repair
- [ ] Test full clean install on fresh machine

## Changelog

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

## Open Questions
None.
