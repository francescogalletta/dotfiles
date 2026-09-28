# AeroSpace Cheatsheet

⌥ option · ⇧ shift · ⇥ tab · ↩ return · ⌫ delete

Source of truth is `aerospace.toml`. `test.sh` fails if the keys here and there diverge.

## Focus & move (vim: H← J↓ K↑ L→)

| Keys          | Action |
|---------------|--------|
| `⌥ H/J/K/L`   | Focus window left / down / up / right |
| `⌥⇧ H/J/K/L`  | Move window (restructures the tree) |

## Workspaces

| Keys      | Action |
|-----------|--------|
| `⌥ 1–9`   | Go to workspace |
| `⌥⇧ 1–9`  | Send window there, you stay put |
| `⌥⇥`      | Bounce between last two workspaces |
| `⌥⇧⇥`     | Move whole workspace to next monitor |

## Layout

| Keys        | Action |
|-------------|--------|
| `⌥/`        | Tile, press again to flip horizontal ↔ vertical; exits accordion |
| `⌥F`        | Fullscreen |
| `⌥⇧F`       | Float / un-float window |
| `⌥T`        | Force back to tiling, fixes an accidental float |
| `⌥I` / `⌥O` | Shrink / grow window by 50px |
| `⌥-` / `⌥=` | Same, alias for standard keyboards |
| `⌥B`        | Balance all splits evenly |
| `⌥↩`        | New Ghostty window, from anywhere |

## Service mode (`⌥⇧;` to enter)

| Keys          | Action |
|---------------|--------|
| `R`           | Flatten layout tree, fixes a tangled mess |
| `F`           | Float / un-float, same as `⌥⇧F` |
| `,`           | Accordion, windows stack with peek edges; `⌥/` to undo |
| `⌫`           | Close all windows except focused |
| `⌥⇧ H/J/K/L`  | Join with window in that direction, nests it |
| `esc`         | Reload config, back to normal |

## Mental model

Every workspace is a **tree** of splits, not a grid. `⌥/` flips a split,
`⌥⇧ H/J/K/L` moves a leaf through the tree, join-with wraps two windows
into a sub-container. Lost? Flatten (`⌥⇧;` then `R`) and rebuild.
Every window full-size and stacked? That is accordion, `⌥/` tiles it again.
