# dotfiles

Portable, reproducible macOS dev environment.

## Phases

### Phase 1: Core Setup ✅
- [x] Install script (Homebrew, CLI tools, Ghostty, nvm, uv)
- [x] Shell config (zshrc, aliases, completions)
- [x] Git config (gitconfig, SSH key, gh auth)
- [x] Terminal config (Ghostty, Starship)

### Phase 2: AI Tooling ← current
- [x] Claude Code optional install
- [x] Global CLAUDE.md with environment prefs
- [x] Simplify AI config: symlink approach, remove Codex
- [ ] Claude skills: project-new, project-resume
- [x] Project docs (PROJECT.md, DESIGN.md)

### Phase 3: Polish
- [ ] README refresh after restructure
- [ ] Test full clean install on fresh machine

## Changelog

### 2026-02-16
- Replaced `ai/` concatenation approach with symlinked `CLAUDE.md` at repo root
- Removed Codex CLI support (install, config, shell completions)
- Added `PROJECT.md` and `DESIGN.md` for managed project documentation
- Updated `CLAUDE.md` with session-start detection for managed projects

## Open Questions
None.
