# Claude Code — Global Instructions

# Tone
- Be concise. Short sentences, no filler.
- Lead with the answer, then explain only if needed.
- Skip pleasantries, preambles, and summaries of what you're about to do.
- Don't narrate your actions — just do them.
- Code over prose when code is clearer.

# Environment
- macOS, Ghostty terminal, zsh with Starship prompt
- Editor: VS Code (`code --wait`)

# Preferred CLI tools
| Instead of | Use | Notes |
|---|---|---|
| `ls` | `eza` | aliased, supports `--icons` |
| `cat` | `bat` | aliased, syntax highlighting |
| `grep` | `rg` | ripgrep |
| `find` | `fd` / `fzf` | fuzzy finding |

# Language runtimes
- **Node.js**: managed via `nvm` (lazy-loaded — don't source nvm.sh manually)
- **Python**: managed via `uv` (use `uv run`, `uv pip`, `uv venv`)

# Git & GitHub
- Authenticated via `gh` CLI
- SSH key configured (ed25519)
- Use `gh` for PR/issue operations

# Shell aliases
- `ls` → `eza --icons`
- `ll` → `eza --icons -la`
- `lt` → `eza --icons --tree --level=2`
- `cat` → `bat`
- `o` / `finder` → `open .`
- `mkcd <dir>` → mkdir + cd
- `fcd` → fzf directory jumper

## Directory Navigation
- `personal_drive` → Personal Google Drive
- `monzo_drive` → Monzo Google Drive
- `analytics` → Monzo analytics repo
- `wearedev` → Monzo wearedev repo

# Dotfiles

System config is managed through `~/dotfiles` and symlinked into place. When changing any config (Claude settings, shell, editor, etc.), prefer editing the source in `~/dotfiles/` rather than the symlink target. After making changes, prompt to ship them.

# Project Documentation

Managed projects are scaffolded with `/project-new` and use `PRD.md` + `TASKS.md` + `DESIGN.md`.

- Run `/project-resume` at session start to orient yourself
- Use `/ship` when committing and pushing work
- After a design/architecture decision: append an entry to `DESIGN.md` (append-only, never edit past entries)
- After completing a task: mark it done in `TASKS.md` and append a changelog entry

# Architecture & Stack Decisions

When discussing architecture or stack choices, always present 2–3 concrete options with a trade-off table before recommending one:

```
| Option | Pros | Cons | Best when |
```

Then state your recommendation and why. Don't skip straight to the answer — the table is the answer.

# Prototyping

New projects live at `~/projects/<name>/` (each its own git repo).
Templates are at `~/dotfiles/templates/<archetype>/`.
Standard Makefile targets on every project: `make dev`, `make build`, `make test`, `make shell`, `make logs`, `make stop`.

- `/project-new` — scaffold a new project from a template archetype
- `/graduate` — deploy a prototype to Fly.io or GCP Cloud Run
- `/learn` — end-of-session review; propose improvements to CLAUDE.md, templates, skills
- `/explain` — explain a file, diff, or concept with trade-offs and next steps
