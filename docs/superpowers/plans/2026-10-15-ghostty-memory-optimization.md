# Ghostty Memory Optimization & Verification Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Optimize Ghostty configuration to prevent unbounded RAM usage from large scrollback buffers while preserving visual aesthetics, and verify memory footprint stability under live stress testing.

**Architecture:** Update `~/.config/ghostty/config` with calibrated buffer limits, validate configuration syntax using Ghostty's native CLI, and measure memory metrics (`RSS`, `Physical Footprint`, and `IOSurface`/`IOAccelerator` memory regions via `vmmap` and `ps`) before and after a high-volume styled text flood.

**Tech Stack:** Ghostty 1.3.1 (Metal/CoreText, macOS ARM64), Bash/Zsh/Fish, macOS diagnostic tools (`vmmap`, `ps`).

**Spec:** System memory inspection from PID 49922 showing ~162.5 MB footprint (~72 MB Metal graphics, ~41 MB IOSurface, ~15 MB heap) with a 100,000-line scrollback buffer configured.

## Global Constraints

- Preserve `theme = TokyoNight`, `font-family = "JetBrainsMono Nerd Font"`, `font-size = 20`, and `font-feature = ss19`.
- Keep `background-blur` disabled to avoid macOS compositor memory growth.
- Maintain custom keybinds for `tuios` and `tmux` passthrough (`ctrl+space=unbind`, `cmd+t=unbind`, `cmd+w=unbind`, `cmd+k=unbind`).
- All configuration changes must pass `/Applications/Ghostty.app/Contents/MacOS/ghostty +validate-config` with zero errors.

## Review Focus

1. **Config Syntax Errors:** Invalid keys or values in `~/.config/ghostty/config` causing Ghostty to fail validation or fallback silently.
2. **Scrollback Usability Truncation:** Setting the limit too low (e.g., < 2,000 lines) breaking interactive workflows like reviewing long git diffs.
3. **Live Reload Failure:** Ghostty not picking up the changed config without a restart or crashing active `tuios` sessions.
4. **Memory Leak Under Load:** Rapid scrolling text generating oversized pages that fail to prune cleanly.
5. **VRAM / Unified Memory Spike:** Glyph atlas exploding under complex unicode/nerd fonts.

---

### Task 1: Baseline Recording and Configuration Tuning

**Files:**
- Modify: `/Users/keita/.config/ghostty/config`
- Create: `/Users/keita/.config/ghostty/memory-audit.log`

**Interfaces:**
- Consumes: Current Ghostty PID (`49922`) and `~/.config/ghostty/config`.
- Produces: Calibrated `scrollback-limit` and baseline metrics recorded in `memory-audit.log`.

- [ ] **Step 1: Record baseline memory metrics to log**

```bash
PID=$(pgrep -f "Ghostty.app/Contents/MacOS/ghostty" | head -n1)
echo "=== Baseline Ghostty Memory (PID: $PID) ===" > /Users/keita/.config/ghostty/memory-audit.log
ps -p "$PID" -o pid,%cpu,%mem,rss,vsz,command >> /Users/keita/.config/ghostty/memory-audit.log
vmmap -summary "$PID" | grep -E "(Physical footprint|TOTAL|IOSurface|IOAccelerator|MALLOC_SMALL|VM_ALLOCATE)" >> /Users/keita/.config/ghostty/memory-audit.log
```

- [ ] **Step 2: Update `~/.config/ghostty/config` with calibrated scrollback limit**

Adjust `scrollback-limit` from `100000` to a balanced `15000` lines (providing ample history while capping buffer RAM to ~15-25 MB per surface):

```ini
# ─── Scrollback ────────────────────────────────────────────────────────────────
# Capped at 15,000 lines to prevent runaway RAM usage during heavy builds/logs
scrollback-limit = 15000
```

- [ ] **Step 3: Validate configuration syntax using Ghostty CLI**

Run:
```bash
/Applications/Ghostty.app/Contents/MacOS/ghostty +validate-config
```
Expected: Exit code 0 with no error output.

- [ ] **Step 4: Commit configuration update to dotfiles git repo**

```bash
git -C /Users/keita/.config add ghostty/config
git -C /Users/keita/.config commit -m "perf(ghostty): tune scrollback-limit to 15k to cap memory usage"
```

---

### Task 2: Live Verification and Reload Confirmation

**Files:**
- Modify: `/Users/keita/.config/ghostty/memory-audit.log`

**Interfaces:**
- Consumes: Running Ghostty process PID (`49922`).
- Produces: Verified active configuration state without process disruption.

- [ ] **Step 1: Verify Ghostty process remains healthy and running**

Run:
```bash
kill -0 $(pgrep -f "Ghostty.app/Contents/MacOS/ghostty" | head -n1)
```
Expected: Exit code 0 (process is alive and running).

- [ ] **Step 2: Check current memory status after config update**

Run:
```bash
PID=$(pgrep -f "Ghostty.app/Contents/MacOS/ghostty" | head -n1)
echo -e "\n=== Post-Config Reload Memory (PID: $PID) ===" >> /Users/keita/.config/ghostty/memory-audit.log
ps -p "$PID" -o pid,%cpu,%mem,rss,vsz,command >> /Users/keita/.config/ghostty/memory-audit.log
vmmap -summary "$PID" | grep -E "(Physical footprint|TOTAL|IOSurface|IOAccelerator|MALLOC_SMALL|VM_ALLOCATE)" >> /Users/keita/.config/ghostty/memory-audit.log
```

---

### Task 3: Scrollback Flood & Pruning Stress Test

**Files:**
- Modify: `/Users/keita/.config/ghostty/memory-audit.log`

**Interfaces:**
- Consumes: Active terminal session / shell.
- Produces: Empirical proof of memory bounding under a 50,000-line colored text flood.

- [ ] **Step 1: Run flood stress test**

Generate 50,000 lines of colored, formatted ANSI text through a subshell to force scrollback pruning beyond the 15,000 line limit:

```bash
python3 -c '
import sys
for i in range(50000):
    sys.stdout.write(f"\033[38;5;{i%256}m[STRESS-TEST line {i:05d}] Testing Ghostty scrollback memory pruning with unicode 🚀 ── \033[0m\n")
' > /tmp/ghostty_flood.txt
cat /tmp/ghostty_flood.txt > /dev/null
rm /tmp/ghostty_flood.txt
```

- [ ] **Step 2: Measure post-flood memory metrics**

Run:
```bash
PID=$(pgrep -f "Ghostty.app/Contents/MacOS/ghostty" | head -n1)
echo -e "\n=== Post-Stress Test Memory (PID: $PID) ===" >> /Users/keita/.config/ghostty/memory-audit.log
ps -p "$PID" -o pid,%cpu,%mem,rss,vsz,command >> /Users/keita/.config/ghostty/memory-audit.log
vmmap -summary "$PID" | grep -E "(Physical footprint|TOTAL|IOSurface|IOAccelerator|MALLOC_SMALL|VM_ALLOCATE)" >> /Users/keita/.config/ghostty/memory-audit.log
```

- [ ] **Step 3: Verify memory boundary compliance**

Verify that:
1. Physical footprint remains bounded (< 250 MB).
2. `VM_ALLOCATE` remains minimal (< 5 MB, confirming zero page recycling leaks).
3. The terminal window responds cleanly and renders without latency.
