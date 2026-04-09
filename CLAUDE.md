# Claude Code — Global Instructions

# Tone
- Be concise. Short sentences, no filler.
- Lead with the answer, then explain only if needed.
- Skip pleasantries, preambles, and summaries of what you're about to do.
- Don't narrate your actions — just do them.
- Code over prose when code is clearer.

# Environment
- macOS, Cursor editor (primary IDE + terminal), Ghostty terminal (fallback), zsh with Starship prompt
- Editor: Cursor (`code --wait`)

# Preferred CLI tools
| Instead of | Use | Notes |
|---|---|---|
| `ls` | `eza` | aliased, supports `--icons` |
| `cat` | `bat` | aliased, syntax highlighting |
| `grep` | `rg` | ripgrep |
| `find` | `fd` / `fzf` | fuzzy finding |

# Language runtimes
- **Node.js**: managed via `nvm` (lazy-loaded — don't source nvm.sh manually)
- **Python**: runs inside Docker containers only — never install Python or pip on the host. Use `uv` as the package manager inside containers (see Prototyping section).

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

# Agent Behaviour — Non-Negotiable

**Run tests yourself. Fix failures yourself. Never hand broken code to the user.**

1. After every code change, run the project's test command (typically `make test`) using the Bash tool.
2. If tests fail, read the output, diagnose the cause, fix it, and run again.
3. Repeat until the full suite is green.
4. Only then commit and report back.

Never ask the user to run tests, copy-paste errors, or diagnose failures. You have a Bash tool — use it.

# Prototyping

New projects live at `~/projects/<name>/` (each its own git repo).
Templates are at `~/dotfiles/templates/<archetype>/`.
Standard Makefile targets on every project: `make dev`, `make build`, `make test`, `make shell`, `make logs`, `make stop`.

All Python runs inside Docker. Dockerfiles use `uv` (not pip) as the package manager:
```dockerfile
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev
```

Dependencies are declared in `pyproject.toml` with a `uv.lock` lockfile for reproducibility. Never use `requirements.txt` or `pip install`.

- `/project-new` — scaffold a new project from a template archetype
- `/graduate` — deploy a prototype to Fly.io or GCP Cloud Run
- `/learn` — end-of-session review; propose improvements to CLAUDE.md, templates, skills
- `/explain` — explain a file, diff, or concept with trade-offs and next steps
