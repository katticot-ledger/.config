# Rex Agent Auto-Resume Architecture

Interactive visual architecture diagram: **[`AGENT_RESUME.html`](AGENT_RESUME.html)**.

This document describes the auto-resume system for AI coding agents (`claude`, `codex`, `pi`, `antigravity`) running inside Rex multiplexer panes.

---

## 1. Overview & Components

The resume subsystem consists of three components:

1. **[`init.lua`](init.lua)**:
   - Evaluated by Rex on server startup and on config reload (`ctrl+b shift+r`).
   - Spawns `rex-agentd` detached (`rex.exec.start(..., {detach = true})`).
   - On config reload, signals a running daemon using `kill -HUP <pid>` via `rex.exec` so that existing agents are immediately re-scanned without duplicate daemon processes.

2. **[`bin/rex-agentd`](bin/rex-agentd)**:
   - Background daemon managing persistence, lifecycle events, and resume injections.
   - Maintains SQLite pin store at `~/.config/rex-agents/pins.db` (WAL mode).
   - Re-keys pins across Rex server restarts and machine reboots.
   - Watches Rex event stream (`rex events --all`) for close/destroy events.
   - Runs a 30-second fallback scanner (`fallback_watch`) that matches unannounced agent panes against on-disk transcripts.

3. **[`bin/rex-agent-announce`](bin/rex-agent-announce)**:
   - Harness hook (`SessionStart` for Claude/Codex, `PreInvocation` for Antigravity).
   - Emits an `OSC 7501` terminal escape sequence containing `session_id` and `cwd` directly to the pane's `/dev/tty...`.

---

## 2. Pin Store Schema (`pins.db`)

Stored at `~/.config/rex-agents/pins.db`:

```sql
CREATE TABLE pins(
  block_id TEXT PRIMARY KEY,       -- Current Rex block UUID (e.g. block:01a1bc5d-...)
  agent TEXT NOT NULL,             -- claude | codex | pi | antigravity
  session_id TEXT NOT NULL,        -- Harness session UUID / conversation ID
  cwd TEXT NOT NULL,               -- Working directory of the agent
  rex_session_id TEXT NOT NULL,    -- Rex session ID (e.g. session:01a1bc5c-...)
  extra_args TEXT NOT NULL DEFAULT '', -- Launch flags (--dangerously-skip-permissions, YOLO, etc.)
  session_label TEXT NOT NULL DEFAULT '', -- Rex session label (e.g. openrig-seats)
  window_label TEXT NOT NULL DEFAULT '',  -- Rex window/tab label
  pane_index INTEGER NOT NULL DEFAULT -1, -- Pane index inside the window layout
  updated_at TEXT DEFAULT (datetime('now'))
);
```

---

## 3. How Auto-Resume Works Across Reboots & Restarts

### Why Old Systems Failed
Previously, pins were keyed solely by Rex `block_id`. When Rex restarted or macOS rebooted, Rex created fresh windows and generated brand-new block UUIDs. The daemon saw the old block IDs missing from Rex's alive list and ran `pin_prune`, permanently wiping saved agent sessions.

### Current Restart-Proof Design
1. **Layout & Context Persistence**:
   - Every pin records `(session_label, window_label, pane_index, cwd)`.
2. **Reconciliation (`resume_all`)**:
   - When Rex starts up, restored panes open as empty login shells (`fish`, `zsh`, `bash`).
   - If an existing pin's `block_id` is missing from the live session, `rex-agentd` searches for an empty shell in the **same session and window** matching `pane_index` (or matching `cwd`).
   - It re-keys the database record to the new `block_id`.
3. **Command Injection**:
   - Once verified as an `empty_shell` (no active foreground process and no status records), `rex-agentd` sends the resume command:
     - **Claude**: `cd -- '<cwd>' && exec claude --resume '<session_id>' <flags>`
     - **Codex**: `cd -- '<cwd>' && exec codex resume '<session_id>' <flags>`
     - **Pi**: `cd -- '<cwd>' && exec pi --session '<session_id>' <flags>`
     - **Antigravity**: `cd -- '<cwd>' && exec agy --conversation '<session_id>' <flags>`
4. **Pruning Safeguards**:
   - Pins are **never** deleted simply because a `block_id` changed.
   - A pin is deleted only when Rex explicitly emits a `session_destroyed` or `block_closed` event.

---

## 4. Fallback Discovery (No-Hook & Detached Panes)

When an agent harness runs inside a background service (e.g. Codex app-server), the hook subprocess has no controlling terminal (`tty = '??'`) and cannot print the `OSC 7501` escape sequence into Rex.

`rex-agentd` handles this automatically:
- Every 30 seconds, `fallback_watch` inspects Rex panes running an agent process (`claude`, `codex`, `pi`, `agy`) that lack an active pin.
- It scans the agent's local transcript indexes on disk:
  - **Claude**: `~/.claude/projects/` & session logs
  - **Codex**: `~/.codex/sessions/`
  - **Pi**: `~/.pi/agent/sessions/`
  - **Antigravity**: `~/.gemini/antigravity-cli/conversations/`
- It matches the newest session for that pane's `cwd` and creates the pin automatically.
- To prevent cross-wiring, if multiple panes share the same `cwd`, sessions already assigned to another pane are excluded.

---

## 5. Reload & Signals

- **Config Reload**:
  Pressing `ctrl+b shift+r` or running `rex config reload` runs `init.lua`.
  `init.lua` reads `~/.local/state/rex-agents/agentd.lock` and sends `kill -HUP <pid>` to the live daemon.
- **SIGHUP Handler**:
  On `SIGHUP`, the daemon interrupts its event wait and immediately executes `resume_all()` to revive any empty panes.
- **Control FIFO**:
  Writing to `~/.local/state/rex-agents/agentd.fifo` (e.g. `echo reload > ~/.local/state/rex-agents/agentd.fifo`) also triggers an instant resume pass.

---

## 6. Troubleshooting & Diagnostics

### View Active Pins
```sh
sqlite3 -header -column ~/.config/rex-agents/pins.db "SELECT block_id, agent, session_id, cwd, session_label, window_label FROM pins;"
```

### View Daemon Logs
```sh
tail -n 50 ~/.local/state/rex-agents/agentd.log
```

### View Event History
```sh
sqlite3 -header -column ~/.config/rex-agents/pins.db "SELECT ts, kind, block_id, detail FROM events ORDER BY ts DESC LIMIT 25;"
```

### Force Manual Resume Pass
```sh
rex config reload
# OR
kill -HUP $(cat ~/.local/state/rex-agents/agentd.lock)
```
