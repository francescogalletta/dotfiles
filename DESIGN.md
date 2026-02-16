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
