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

## ADR-010: Warp config management
**Date:** 2026-03-13
**Decision:** Manage Warp's file-based configs (custom themes, keybindings) as YAML dotfiles in `config/warp/`, symlinked to `~/.warp/`. Non-file settings (font, opacity, theme selection) sync via Warp's built-in account cloud sync.
**Reason:** Warp stores some preferences in its own database rather than in files. We manage what we can (themes, keybindings) as dotfiles and rely on Warp's cloud sync for the rest. The install script nudges the user to log in if Warp is detected.

## ADR-011: Transparent macOS theme
**Date:** 2026-03-13
**Decision:** Created a shared "Transparent macOS" color theme for both Ghostty and Warp terminals. Uses Apple HIG system palette, 85% background opacity with blur for a frosted glass effect.
**Reason:** Consistent visual identity across terminals. Apple system colors ensure the theme feels native on macOS. The theme is defined once conceptually (same hex values) but formatted per terminal's config syntax (key=value for Ghostty, YAML for Warp).

## ADR-012: cmux preferences via plist import
**Date:** 2026-03-13
**Decision:** cmux preferences (keybindings, sidebar layout) are stored as a macOS plist in `config/cmux/` and restored via `defaults import` during install, rather than symlinked.
**Reason:** cmux stores preferences in macOS defaults (a binary plist database), not a file that can be reliably symlinked. `defaults import/export` is the standard mechanism for persisting and restoring these settings across machines.
