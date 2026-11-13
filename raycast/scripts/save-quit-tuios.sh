#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Save & Quit TUIOS
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 💾
# @raycast.packageName TUIOS
# @raycast.needsConfirmation true

# Documentation:
# @raycast.description Save all TUIOS session states and cleanly stop the daemon
# @raycast.author Keita

set -u

# 1. Comprehensive PATH resolution for macOS GUI launchd environment
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

if ! command -v tuios >/dev/null 2>&1; then
  # Fallback: attempt to query user's login shell
  if [ -n "${SHELL:-}" ] && [ -x "$SHELL" ]; then
    SHELL_TUIOS=$("$SHELL" -l -c 'command -v tuios 2>/dev/null' || true)
    if [ -n "$SHELL_TUIOS" ] && [ -x "$SHELL_TUIOS" ]; then
      TUIOS_BIN="$SHELL_TUIOS"
    fi
  fi
else
  TUIOS_BIN=$(command -v tuios)
fi

if [ -z "${TUIOS_BIN:-}" ]; then
  echo "Error: tuios not found in PATH"
  exit 1
fi

# 2. Check if daemon is active before attempting kill (Idempotency)
if ! "$TUIOS_BIN" list-sessions >/dev/null 2>&1; then
  echo "TUIOS is not running"
  exit 0
fi

# 3. Execute kill-server and capture stdout + stderr
raw_output=$("$TUIOS_BIN" kill-server 2>&1)
exit_code=$?

# 4. Clean output: strip ANSI color escapes and collapse newlines for Raycast HUD
clean_output=$(printf '%s' "$raw_output" \
  | sed -E $'s/\x1B\\[[0-9;]*[a-zA-Z]//g' \
  | tr '\r\n' ' ' \
  | sed -E 's/ +/ /g; s/^ //; s/ $//')

# 5. Handle outcome
if [ $exit_code -eq 0 ]; then
  echo "TUIOS state saved & stopped cleanly"
  exit 0
else
  err_msg="${clean_output:-timeout or server unresponsive}"
  echo "TUIOS error: $err_msg"
  exit 1
fi
