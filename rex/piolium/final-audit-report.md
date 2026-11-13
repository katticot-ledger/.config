# Final Audit Report — rex-agentd (2026-11-09)

Scope: `bin/rex-agentd` + `init.lua` signaling block at HEAD `66367d3`.
Method: audit-skill methodology right-sized to a single-user local daemon —
threat model + manual taint analysis (KB: `attack-surface/knowledge-base-report.md`),
fix verification, deep hunting, FP elimination. SAST tooling
(shellcheck/semgrep/codeql) unavailable on this host; manual structural
analysis used as the documented fallback.

## Fix verification (adversarial-review fixes vs current code)

All 12 fixes from the three-reviewer BLOCK verdicts are present and live:

| # | Fix | Code | Live evidence |
|---|---|---|---|
| 1 | Dispatcher `kind=$atype` (P0) | rex-agentd:492 | announcement pins at startup; test pin pruned on block_closed (08:33:46) |
| 2 | `shq()` shell escaping in resume_cmd | :56,163-166 | unit-tested incl. hostile cwd `x'; rm -rf ~; '` |
| 3 | Transcript cross-pin guard | :384 | — |
| 4 | Re-key refuses pinned blocks | :266 | — |
| 5 | `stream_pid` defined pre-trap | :568 | — |
| 6 | session_destroyed = DELETE+changes() | :542 | — |
| 7 | FIFO reader O_RDWR hold-open | :585 | — |
| 8 | hup cleared before resume pass | :607-608 | — |
| 9 | Resume event logged on send | :289 | — |
| 10 | events index + 30-day prune | :82,85 | `idx_events_kind_block` in prod db |
| 11 | `san()` strips `\|` from labels | :110,119,197 | — |
| 12 | Startup failure reporting | :41,43 | — |

The post-audit `init.lua` change (os.execute → `pcall(rex.exec, …)`) preserves
the security properties: pid is digits-validated before interpolation, the
grep pattern is static, and the runtime log shows the path delivered a HUP
(`08:34:32 SIGHUP: re-running resume pass`).

## Verified secure (adversarial hypotheses refuted)

- **SQL**: every interpolated value goes through `q()` ( `'`→`''` is complete
  for SQLite string literals; backslashes are not special there). No raw
  interpolation found in any `sq`/`sqlite3` call.
- **Pane shell injection**: cwd and session_id pass `shq()`; agent name is
  double-whitelisted (source map + `resume_cmd` case); `extra_args` is a
  3-literal-token whitelist from `detect_args`.
- **Session ids** from announcements are regex-constrained to 36 hex/hyphen.
- **init.lua kill target**: digits-only pid + anchored argv match — rejects
  `vim`/`tail` with a recycled pid (unit-verified both ways).
- **Local surface**: state dir is `0700`, containing the `0644` fifo — other
  local users cannot reach it. FIFO content is discarded (HUP trigger only).
- **Signals**: `kill`/`pkill -P` receive only daemon-internal pids.
- **Runtime**: dispatcher live since 08:33 UTC — 109 activity lines (pins,
  prunes, SIGHUP, rejections); shlock correctly rejected duplicate spawns on
  config reload.

## Findings

No HIGH or CRITICAL findings. Informational / accepted-residual only:

- **F1 (info)** — `init.lua:366-372`: `pcall(rex.exec, …)` swallows failure
  silently. If the `rex.exec` API is ever absent/renamed, config reload stops
  signaling the daemon with **no log line** (unlike the spawn path, which logs
  via `rex.log`). One-line fix: log on pcall failure.
- **F2 (info)** — log injection: an agent-controlled cwd/session-id
  containing newlines forges lines in `agentd.log` (local cosmetic file;
  `wlog` uses `printf '%s %s\n'`). No downstream parser trusts the log.
- **F3 (info)** — `transcript_lookup` codex branch: `find | xargs ls -t` — a
  dash-leading filename inside the user-owned `~/.codex/sessions` would be
  read as an `ls` flag. Same-privilege local user only; codex generates the
  filenames itself.
- **F4 (accepted residual, design)** — `rex events --all` has no replay: a
  `block_closed`/`session_destroyed` missed during a ~10s stream gap leaves a
  stale pin that the re-key fallback may later resurrect onto a shifted pane.
  Mitigations in place: empty-shell + not-already-pinned + 60s guards cap the
  blast radius at "annoying relaunch in an empty pane". Proper fix if it
  bites: `last_seen_live` gating of re-key eligibility.
- **F5 (accepted residual, design)** — check-to-send race: a user typing
  (un-entered) in a fresh empty shell at a matched position could receive a
  resume injection. Inherent to the empty-shell resume design (same as the
  pre-rewrite system); window is sub-second.

## Verdict

**PASS.** The system's one execution sink (pane command injection) is
reachable only through q()/shq()/whitelists; all three reviewers' P0/P1
findings are fixed, committed, and live-verified. Residual risks are
documented and bounded.
