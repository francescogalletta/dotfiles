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

# Project Documentation

If `PROJECT.md` exists in the working directory, this is a managed project.
Read it at the start of each session. Keep `PROJECT.md` and `DESIGN.md` updated as you work:
- After completing a task: check it off, append a changelog entry to PROJECT.md
- After a design/architecture decision: append an ADR to DESIGN.md (create if needed)
- Don't rewrite unchanged sections. Match existing style.

**CRITICAL: Update docs BEFORE committing.**
When asked to commit changes:
1. Update PROJECT.md changelog (and DESIGN.md if applicable)
2. Stage all changes including updated docs
3. Commit everything together
4. Then push

Never commit code first and update docs after — the changelog must be in the same commit as the changes it documents.
