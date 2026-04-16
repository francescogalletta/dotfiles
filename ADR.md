# Architecture Decision Records

Reverse-chronological. Newest entry at top. After adding an entry, update PRD.md to reflect the current state.

---

## ADR-017: Standalone IDE installer with dynamic default
**Date:** 2026-04-16
**Decision:** Extracted editor installation and default selection into a standalone `ide.sh` script, called by `install.sh`. Multi-select menu (VS Code, Zed, Cursor), installs via `brew install --cask`, prompts for default. Writes `~/.editor_env` (EDITOR/VISUAL for zsh) and `~/.gitconfig.local` (git core.editor). Zed is the primary editor. Shell functions (`e()`, `Ctrl+O`) derive the IDE command from `$EDITOR` via `${EDITOR%% *}`.
**Reason:** IDE installation is a separate concern from system bootstrapping. Multi-select lets you install multiple editors and pick a default. Generated files keep checked-in dotfiles machine-agnostic.
**Supersedes:** ADR-014, ADR-016

## ADR-016: Zed as secondary editor
**Date:** 2026-04-14
**Decision:** Added Zed editor to managed dotfiles alongside Cursor. Config in `config/zed/`, symlinked to `~/.config/zed/`. Unified keybinding scheme. Added `z` shell alias.
**Reason:** Zed is native, GPU-accelerated, near-instant startup. Complements Cursor for quick edits without Electron overhead.
**Superseded by:** ADR-017

## ADR-015: uv inside containers, no Python on host
**Date:** 2026-04-09
**Decision:** All Python templates use `uv sync --frozen` with `pyproject.toml` + `uv.lock`. uv is installed inside Docker containers only. Never install Python or pip on the host.
**Reason:** 10-100x faster than pip. `uv.lock` gives reproducible builds. Zero host dependencies beyond Docker.

## ADR-014: Simplify to Cursor-primary workflow
**Date:** 2026-04-09
**Decision:** Removed cmux, Midnight Commander, micro. Simplified to: Cursor (primary IDE), Ghostty (fallback terminal), Warp (deprioritized). Unified on Catppuccin Mocha theme.
**Reason:** Too many overlapping tools. Cursor 3's integrated terminal + AI makes it viable as single pane.
**Supersedes:** ADR-011, ADR-012
**Superseded by:** ADR-017

## ADR-013: Prototyping fast-path via templates + skills
**Date:** 2026-03-14
**Decision:** Added `templates/` with archetypes (`data`, `web`, `api`, `cli`, `agent`). Each is a complete Docker-based project. Skills: `/project-new`, `/graduate`, `/learn`, `/explain`.
**Reason:** Templates encode stack choices so the agent has an opinionated starting point. Docker is the abstraction for local-to-production parity.

## ADR-012: cmux preferences via plist import
**Date:** 2026-03-13
**Decision:** cmux preferences stored as macOS plist, restored via `defaults import`.
**Reason:** cmux uses macOS defaults, not files that can be symlinked.
**Superseded by:** ADR-014

## ADR-011: Transparent macOS theme
**Date:** 2026-03-13
**Decision:** Shared color theme for Ghostty and Warp using Apple HIG system palette, 85% opacity with blur.
**Reason:** Consistent visual identity. Native feel on macOS.
**Superseded by:** ADR-014

## ADR-010: Warp config management
**Date:** 2026-03-13
**Decision:** Warp file-based configs (themes, keybindings) as YAML dotfiles in `config/warp/`, symlinked to `~/.warp/`. Non-file settings sync via Warp's cloud.
**Reason:** Warp stores some prefs in its database. Manage what we can as dotfiles, rely on cloud sync for the rest.

## ADR-009: Cursor and global gitignore managed as dotfiles
**Date:** 2026-03-10
**Decision:** Added Cursor settings/keybindings and global gitignore to the repo. Also added `.zprofile`.
**Reason:** Completes the managed config set — editor, git hygiene, shell profile.

## ADR-008: Brewfile for package management
**Date:** 2026-03-10
**Decision:** Declarative `Brewfile` replaces hardcoded package list. `install.sh` uses `brew bundle install`.
**Reason:** Easier to diff, declarative. Only includes packages the dotfiles manage.

## ADR-007: Config directory organization
**Date:** 2026-02-17
**Decision:** All tool-specific configs in `config/{tool}/` subdirectories. Traditional dotfiles (zshrc, gitconfig) at root.
**Reason:** Visual consistency. Easier to find configs. Symlink targets vary but source org is uniform.

## ADR-006: Sync script for symlink repair
**Date:** 2026-02-16
**Decision:** `sync.sh` checks and repairs broken symlinks. Definitions in shared `links.sh` sourced by both `install.sh` and `sync.sh`.
**Reason:** Apps can overwrite symlinks with regular files. `sync.sh` detects and fixes drift anytime.

## ADR-005: Project documentation convention
**Date:** 2026-02-16
**Decision:** Managed projects use `ADR.md` (reverse-chronological decision log), `PRD.md` (current project state), and `TASKS.md` (progress, changelog). `TASKS.md` presence signals a managed project to AI agents.
**Reason:** Gives agents fast context. ADR.md newest-first ensures LLMs see the latest decisions first in context. PRD.md must always reflect current state (synced with ADR.md). TASKS.md tracks progress.
**Updated:** 2026-04-16 — changed from PROJECT.md + DESIGN.md to ADR.md + PRD.md + TASKS.md

## ADR-004: Codex CLI removed
**Date:** 2026-02-16
**Decision:** Removed Codex CLI support.
**Reason:** Unused. Agent-agnostic design (ADR-003) makes re-adding trivial.

## ADR-003: AI config as symlinked dotfile
**Date:** 2026-02-16
**Decision:** `CLAUDE.md` at repo root, symlinked to `~/CLAUDE.md`. Agent-agnostic: adding another agent = another file + symlink.
**Reason:** Symlinks make edits bidirectional. Replaced one-way `ai/` concatenation approach.

## ADR-002: Idempotent install script
**Date:** 2026-02-16
**Decision:** Single `install.sh` handles everything. Safe to re-run. Skips installed tools. Backs up existing configs.
**Reason:** One command for fresh machines.

## ADR-001: Symlinked dotfiles
**Date:** 2026-02-16
**Decision:** Config files live in `~/dotfiles` and are symlinked to their expected locations.
**Reason:** Edits to live configs are automatically version-controlled. No copy/sync step.
