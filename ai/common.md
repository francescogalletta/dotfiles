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
