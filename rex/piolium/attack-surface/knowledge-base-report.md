# Knowledge Base — rex-agentd security audit (2026-11-09)

Target: `bin/rex-agentd` (625-line POSIX sh daemon, macOS bash-3.2 sh-mode, `set -u`)
+ `init.lua` reload-signaling block. Audited at HEAD `66367d3`;
`bin/rex-agentd` byte-identical to fix commit `4522731`.

## Component inventory (SBOM-lite)

| Component | Role | Runtime context |
|---|---|---|
| `/bin/sh` (bash 3.2 sh-mode) | daemon runtime | detached, user session |
| `sqlite3` (Apple) | pin store `~/.config/rex-agents/pins.db`, WAL | CLI, one connection per call, `.timeout 2000` |
| `jq` | all JSON parsing (event stream, block process, transcript headers) | CLI |
| `sed`/`awk`/`grep`/`tr`/`cut` | extraction + sanitization (`q`, `shq`, `san`) | CLI |
| `rex` CLI (`RexServer.app`) | server API: ls/window/block/events/send/send-key | local server, `--autostart=false` |
| `/usr/sbin/lsof`, `ps`, `/usr/bin/shlock`, `mkfifo`, `mktemp`, `pkill`, `date -j -f` | resolution, locking, control | macOS local |
| Agent transcript stores | `~/.claude/projects/*`, `~/.pi/agent/sessions/*`, `~/.codex/sessions/**`, `~/.gemini/antigravity-cli/conversation_summaries.db` | read-only, agent-written |
| Lua (`init.lua`) | config plugin: spawn + SIGHUP signaling via `rex.exec` | inside Rex server |

No network surface beyond the local Rex server. No packaged dependencies.

## Trust boundaries

- **T1 Rex event stream** (server-generated JSON; reflects all pane activity)
- **T2 OSC 7501 announcement `msg`** — **agent-controlled** (hooks run inside
  agent processes; prompt-injected content can reach this string)
- **T3 agent transcript files on disk** — agent-written
- **T4 spool `announcements.log`** — hook-written (agent-influenced)
- **T5 local files**: `agentd.fifo`, `agentd.lock`, state dir (user-only, `0700`)
- **T6 `pins.db`** — self-written (single writer, shlock-enforced)

## Critical DFD slice — the resume flow

```
T2 msg ──sed sid([0-9a-f-]{36})──┐
T2 msg ──sed cwd(raw)─────────────┤
T4 spool (agent|sid|cwd|tp|ts)───┤──> pin_upsert (q(): ' -> '') ──> pins.db
T3 transcript (sid, cwd)──────────┘                                     │
                                                                       v
resume_all ──> resume_cmd (shq(): ' -> '\'') ──> rex send ──> PANE SHELL EXECUTES IT
```

The pane-execution sink is **by design** (the system's purpose is to inject a
resume command). The security property is therefore: *only values that passed
q() (SQL), the agent-name whitelist, the session-id regex, and shq() (shell)
reach `rex send`*. `extra_args` is a fixed 3-token whitelist from `detect_args`.

## Taint table (source → sanitization → sink)

| Source | Field | Sanitizer | Sink(s) | Verdict |
|---|---|---|---|---|
| T2/T4 announcement | session_id | regex `[0-9a-fA-F-]{36}` (T2) / raw (T4) | SQL via q(); shell via shq() | safe |
| T2/T4/T3 announcement/transcript/process JSON | cwd | raw capture | SQL via q(); shell via shq(); log (see F2) | safe at sinks |
| T2/T4 | agent name | `agent_from_id` prefix whitelist / `resume_cmd` case whitelist | `resume_cmd` dispatch | safe |
| process JSON | argv0 | case map (pi/claude/codex/agy) | pin agent, transcript lookup | safe |
| ps output | launch flags | `detect_args` literal echo only (3 tokens) | `extra_args` → resume cmd tail | safe |
| T1 wire | block_id/session_id | q() in SQL; quoted literal in `case` patterns | SQL, dedup lists | safe |
| T5 lock file | pid | digits-only regex + anchored `^(/bin/)?sh .*config/rex/bin/rex-agentd$` (init.lua) | `kill -HUP` | safe |
| T5 fifo | line content | discarded (triggers HUP only) | none | safe |
| T3 transcript paths | dir/file globs | enumerated, never executed; `grep -F` fixed-string | `ls -t`, `head`, jq | safe (see F3) |
| internal | pids (bg children) | never external | `kill`/`pkill -P` | safe |

## Phase 4 extraction targets

N/A — CodeQL has no sh/Lua extractors for this shape and none of
shellcheck/semgrep/codeql are installed on this host. SAST executed as the
manual structural analysis above (fallback documented per audit skill).
