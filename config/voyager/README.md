# ZSA Voyager

Layout lives in Oryx (id `ZlBeJ`): https://configure.zsa.io/voyager/layouts/ZlBeJ/latest/0

Oryx is the editor; this directory versions the layout and documents OS-portability decisions.

## Versioning

`./pull-layout.sh` fetches the latest layout revision from Oryx's GraphQL API into `layout.json`. Run it after saving changes in Oryx, commit the diff. Oryx keeps its own server-side revision history; this snapshot is the copy we own, reviewable in git like every other config.

If the layout ever needs custom QMK (key overrides, `os_detection`), graduate to ZSA's [oryx-with-custom-qmk](https://blog.zsa.io/oryx-custom-qmk-features/) GitHub Actions flow; that repo then becomes the source of truth and this snapshot can retire.

## Kontroll

CLI control of the keyboard via Keymapp's API. Installed by `install.sh` (binary from [zsa/kontroll](https://github.com/zsa/kontroll) releases into `~/.local/bin`); Keymapp itself comes from the Brewfile.

One-time setup: open Keymapp → settings → enable the API, and set Keymapp to launch at login. Then:

```bash
kontroll status            # connected keyboard info
kontroll list              # available layers
kontroll set-layer -i 7    # activate WIN layer
```

## WIN layer (Windows machine)

Base layer assumes macOS. For the Windows machine, add layer 7 "WIN" in Oryx: every key transparent except the overrides below. The board resets to base on unplug, so on Windows a login task runs `kontroll set-layer -i 7` (see `windows/install.ps1` when it lands); manual toggles TO(7)/TO(0) on two free Media-layer keys as fallback.

| Key (current Main assignment) | Mac sends | WIN layer sends |
|---|---|---|
| Left thumb Cmd key | LGUI tap/hold | **LCtrl tap/hold** |
| `W` hold | Cmd+W | **Ctrl+W** |
| `Z` hold | Cmd+Z | **Ctrl+Z** |
| `X` hold | Cmd+X | **Ctrl+X** |
| `C` hold | Cmd+C | **Ctrl+C** |
| `V` hold | Cmd+V | **Ctrl+V** |
| `Esc` (no hold today) | — | **hold = LGUI** (deliberate Win key: Win+L, Win+V, snapping) |

Already portable, no changes needed: home-row Hyper on `A`/`;` (Ctrl+Alt+Shift+Win is collision-free on Windows; re-register the same Raycast hotkeys), home-row Ctrl/Alt/Shift on `S`/`D`/`F`/`J`/`K`/`L`, Nav layer arrows + Home/End/PgUp/PgDn, Nav layer Ctrl+Tab / Ctrl+Shift+Tab tab switching.

Known residue (fix in a v2 "WIN Nav" layer only if it hurts after a week):

- Nav `Cmd+Tab` / `Cmd+Shift+Tab` (app switcher) arrive as Win+Tab / Win+Shift+Tab on Windows — Task View, usable but not Alt+Tab.
- Nav screenshot keys `Cmd+Shift+3/4/5` arrive as Win+Shift+3/4/5, which launches taskbar apps. Windows wants Win+Shift+S.
- v2 approach: clone Nav as layer 8 with Alt+Tab and Win+Shift+S at those positions, and on the WIN layer redefine `N` as tap N / hold MO(8) so the WIN base reaches the corrected Nav. Same pattern for Nav Mous (`B` hold) if needed.
