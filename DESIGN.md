# Design Decisions

## ADR-001: Symlinked dotfiles
**Date:** 2026-02-16
**Decision:** Config files live in ~/dotfiles and are symlinked to their expected locations (~/.zshrc, ~/.gitconfig, etc.)
**Reason:** Edits to live configs are automatically version-controlled. No copy/sync step needed.

## ADR-002: Idempotent install script
**Date:** 2026-02-16
**Decision:** Single `install.sh` handles everything — tool installation, config deployment, optional extras. Safe to re-run.
**Reason:** One command for fresh machines. Skips already-installed tools. Backs up existing configs before replacing.

## ADR-003: AI config as symlinked dotfile
**Date:** 2026-02-16
**Decision:** `CLAUDE.md` lives in the repo root and is symlinked to `~/CLAUDE.md`, same as other dotfiles. Replaced the previous `ai/` directory approach (header + common concatenation).
**Reason:** The concatenation pattern was one-way — edits to ~/CLAUDE.md didn't flow back to the repo. Symlinks solve this. The approach is agent-agnostic: adding a second agent means adding another file + symlink.

## ADR-004: Codex CLI removed
**Date:** 2026-02-16
**Decision:** Removed Codex CLI support (install prompt, config assembly, shell completions).
**Reason:** Unused. Added complexity without value. The agent-agnostic design (ADR-003) means re-adding any agent later is trivial.

## ADR-005: Project documentation convention
**Date:** 2026-02-16
**Decision:** Managed projects use `PROJECT.md` (phases, tasks, changelog) and `DESIGN.md` (ADRs, architecture) at repo root. `PROJECT.md` presence signals a managed project to AI agents.
**Reason:** Gives agents fast context on project state without reading entire codebases. Append-only changelog and ADRs prevent information loss across sessions.

## ADR-006: Sync script for symlink repair
**Date:** 2026-02-16
**Decision:** Added `sync.sh` — a standalone symlink doctor that checks each link and repairs broken ones. Symlink definitions are in a shared `links.sh` sourced by both `install.sh` and `sync.sh`.
**Reason:** Apps like Ghostty can overwrite symlinks with regular files during updates or config resets, causing silent config drift. `install.sh` only runs once; `sync.sh` can be run anytime to detect and fix this. The shared link map (`links.sh`) prevents the two scripts from diverging.

## ADR-007: Config directory organization
**Date:** 2026-02-17
**Decision:** All tool-specific configs live in `config/{tool}/` subdirectories, regardless of deployment target. Traditional dotfiles (zshrc, gitconfig) and global files (CLAUDE.md) remain at root.
**Reason:** Visual consistency in repo structure. Easier to find all tool configs in one place. Symlink targets can differ (`~/.config/`, `~/.claude/`, etc.) but source organization is uniform.

## ADR-008: Brewfile for package management
**Date:** 2026-03-10
**Decision:** Moved the hardcoded package list from `install.sh` into a declarative `Brewfile` at repo root. `install.sh` now uses `brew bundle install` instead of a per-package loop.
**Reason:** Easier to diff, declarative, and `brew bundle dump` can capture what's actually installed. The Brewfile only includes packages the dotfiles manage — work-specific tools are left out.

## ADR-009: Cursor and global gitignore managed as dotfiles
**Date:** 2026-03-10
**Decision:** Added Cursor (editor) settings/keybindings and a global gitignore (`~/.config/git/ignore`) to the repo, symlinked like other configs. Also added `.zprofile` for brew shellenv.
**Reason:** Completes the managed config set — editor, git hygiene, and shell profile were the main gaps. `code` command resolves to Cursor (VS Code fork), so config lives in `config/cursor/`.
