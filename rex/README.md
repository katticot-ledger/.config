# Rex Configuration (`~/.config/rex`)

User configuration for the Rex terminal multiplexer on macOS.

---

## Structure

- **[`init.lua`](init.lua)**: Primary configuration file. Keybindings, modes (fleet, matoury, openrig), window layouts, and daemon autostart.
- **[`AGENT_RESUME.md`](AGENT_RESUME.md)**: Full architecture guide for the agent auto-resume system (`rex-agentd`).
- **[`AGENT_RESUME.html`](AGENT_RESUME.html)**: Interactive Archify architecture diagram.
- **`bin/rex-agentd`**: Background daemon handling session persistence, reboots, and auto-resume injections.
- **`bin/rex-agent-announce`**: Hook script for Claude/Codex/Pi/Antigravity to emit `OSC 7501` status records.
- **`bin/rex-say`**: Deliver text to another block in one call. `rex-say BLOCK TEXT`, `rex-say BLOCK --file PATH`, or stdin. Prints one line (`<block> <program> <state> <result>`); exit 0 sent, 3 queued (agent busy), 4 typed not submitted, 1 failed. Probes the pane first, so it refuses to type over stray input or into a permission prompt. Installed as a symlink at `~/.local/bin/rex-say`.

---

## Keybindings Reference

### Window & Pane Management
- `ctrl+b h/j/k/l` or arrows: Pane navigation.
- `cmd+w`: Close focused pane.
- `shift+cmd+w`: Close active tab/window.
- `ctrl+b shift+r`: Reload config and trigger resume pass (`rex config reload`).

### Modes & Fleets
- `ctrl+b 4`: Enter **Fleet Mode** (press `3` for 3-agent layout, `4` for 2x2 grid).
- `ctrl+b r`: Enter **OpenRig Picker** (`1` = Kernel, `2` = Review, `3` = Dashboard, `4`/`c` = Cockpit).
- `ctrl+b c`: Direct shortcut to **Rig Cockpit**.
- `ctrl+b m`: Enter **Matoury Host Mode** (`n`/`t` = new session, `s` = switch host).

---

## Agent Auto-Resume

See [`AGENT_RESUME.md`](AGENT_RESUME.md) for architecture, schema, signal handling, and diagnostics.
