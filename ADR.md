# Architecture Decision Records

Reverse-chronological. Newest entry at top. After adding an entry, update PRD.md to reflect the current state.

---

## ADR-024: Remove Forge Code
**Date:** 2026-05-17
**Decision:** Removed Forge Code entirely. Deleted `config/forge/forge.toml`, the `links.sh` symlink entry, the `install.sh` install step, the `>>> forge initialize >>>` block from `zshrc`, and the `~/.local/bin/forge` binary. `ZSH_THEME` set to `robbyrussell` (OMZ default) to replace the Forge-owned prompt.
**Reason:** Forge is no longer used. All references cleaned up from dotfiles, install script, and system.

## ADR-023: Zed unified cmd-opt keymap scheme
**Date:** 2026-05-18
**Decision:** Overhauled `config/zed/keymap.json` and `config/zed/settings.json`. All shortcuts unified under the `cmd-opt` modifier prefix. Panel toggles use mnemonic letters (T=terminal, P=project, G=git, A=agent, R=threads). Splits use V (vertical) and H (horizontal). Pane focus uses `cmd-opt-arrow`. Tab navigation uses `cmd-opt-space` / `cmd-opt-tab`. Zoom uses `cmd-opt-m`. Added `"close_panel_on_toggle": true` to settings so `ToggleFocus` panels close when re-triggered while focused. Used Zed's `unbind` syntax (not `null`) for targeted conflict removal. Added `AgentPanel` context bindings: `cmd-n` → new thread, `cmd-opt-t` → close panel. Updated Zed appearance: system-adaptive Catppuccin theme (Frappé dark / Latte light), ZedMono fonts, minimap on hover, git panel docked bottom.
**Reason:** Previous scheme mixed `alt-shift`, `ctrl-shift`, and `ctrl-alt` prefixes with no mnemonic pattern. Ergonomic compact keyboard makes symbol keys costly — modifier+letter is faster. A single prefix (`cmd-opt`) makes the full shortcut set learnable as one group. Context-aware `AgentPanel` bindings allow the same key (`cmd-opt-t`) to toggle terminal from the editor and close the agent panel from within it, reducing the total number of shortcuts to remember.

## ADR-022: Fix OMZ plugins, Codex/Forge Ollama configs, Zed Nerd Font
**Date:** 2026-05-03
**Decision:** Three fixes applied. (1) OMZ plugin symlinks in `install.sh` now create per-plugin directories and symlink individual `.zsh` files with the `.plugin.zsh` suffix that OMZ's `is_plugin()` requires. Previously the entire Homebrew `share/` dir was symlinked, which lacked the expected filename. (2) Codex `config.toml` simplified to top-level `model` and `model_provider` keys (not a `[profiles.default]` section, which only applies with `-p default`). Removed dead `[model_providers.ollama-launch]` block. (3) Forge `forge.toml` trimmed to just `[session]` with `provider_id`/`model_id`. Forge's built-in Ollama provider requires a one-time `forge provider login ollama` to register the endpoint in the macOS keychain; added this interactive step to `install.sh` after Forge installation. (4) Zed terminal `font_family` changed from `JetBrains Mono` to `JetBrainsMono Nerd Font Mono` for glyph support.
**Reason:** OMZ printed "plugin not found" on every shell startup. Codex defaulted to OpenAI's cloud API instead of local Ollama. Forge rejected Ollama with "provider not available" until the keychain entry existed. Zed terminal couldn't render Nerd Font icons from eza/prompt.

## ADR-021: Replace Starship with Oh My Zsh
**Date:** 2026-05-02
**Decision:** Replaced Starship with Oh My Zsh as the shell framework. `zshrc` now uses OMZ with `plugins=(git brew zsh-autosuggestions zsh-syntax-highlighting)` and `ZSH_THEME=""` so Forge's `forge zsh theme` owns the prompt. Homebrew plugin dirs are symlinked into `$ZSH_CUSTOM/plugins/` during install. Bell hooks use `add-zsh-hook` to avoid clobbering OMZ's internal preexec/precmd. History settings (HISTSIZE/SAVEHIST) are placed after `source "$ZSH/oh-my-zsh.sh"` to override OMZ's internal 50000 default. `brew "starship"` and `config/starship.toml` removed.
**Reason:** Forge's `forge zsh setup` checks `${plugins[@]}` for autosuggestions and syntax-highlighting and writes `PROMPT` via `forge zsh theme`. Starship also writes `PROMPT`, causing a conflict. OMZ provides the plugin management Forge expects, adds `git` plugin aliases (`gco`, `gst`, `gaa`, etc.) as a bonus, and cleanly hands prompt ownership to Forge via `ZSH_THEME=""`.

## ADR-020: Add Codex CLI with Ollama provider
**Date:** 2026-05-02
**Decision:** Added Codex (OpenAI's coding agent) as an optional install via `brew install --cask codex`. Config at `config/codex/config.toml` (symlinked to `~/.codex/config.toml`) defines Ollama as the model provider with `gemma4` as the default model. Codex symlink is conditional on `codex` being in PATH.
**Reason:** Codex has native Ollama support, letting it run fully locally with no API key or cloud dependency. `gemma4` is already pulled by `install.sh`, so no extra setup is needed. Added as optional (same pattern as Claude Code and Forge) since it's an AI tool choice.

## ADR-019: Remove Raycast and Cursor/VS Code; Zed-only; Tolaria added
**Date:** 2026-05-02
**Decision:** Removed Raycast from Brewfile and all managed config (`config/raycast/`). Removed Cursor and VS Code from `ide.sh` — Zed is now the only managed editor. Removed `config/cursor/` from the repo. Added Tolaria cask. Renamed deprecated casks `docker` → `docker-desktop` and `google-cloud-sdk` → `gcloud-cli`. Brew bundle output now streams filtered live lines instead of being fully silenced.
**Reason:** Raycast's Homebrew cask consistently times out on Cloudflare R2 during `brew bundle`, blocking the installer. Cursor and VS Code were unused — Zed covers all editor needs. Tolaria fills the knowledgebase gap left by the simplified launcher setup. Cask renames eliminate Homebrew deprecation warnings. Streaming brew output makes install failures visible without digging through logs.

## ADR-018: Obsidian shared config via symlinks + Raycast script commands
**Date:** 2026-05-02
**Decision:** Shared Obsidian config files in `config/obsidian/shared/`, symlinked into each vault's `.obsidian/` directory. Vault paths discovered dynamically from `obsidian.json` via `jq` in `links.sh`. Unified on Minimal theme, starter hotkey set (all macOS-conflict-free), and four community plugins. Raycast added to Brewfile. Custom Raycast Script Command detects frontmost app and displays per-app shortcuts from `config/raycast/shortcuts/`. Per-app shortcut files chosen over README parsing for simplicity and maintainability.
**Reason:** Obsidian stores config per-vault, causing theme/plugin/hotkey divergence across vaults. Symlinks into Google Drive folders were tested and confirmed to work. Dynamic vault discovery avoids hardcoding paths. Raycast config lives in encrypted SQLite (not manageable as plain text), so only install, script commands, and a few `defaults write` values are managed from dotfiles. Cloud sync handles the rest.

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
