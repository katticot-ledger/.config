#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Launch TUIOS (Last Session)
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🖥️
# @raycast.packageName TUIOS

# Documentation:
# @raycast.description Launch Ghostty, attach to the most recent TUIOS session, and focus the window
# @raycast.author Antigravity

set -u

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

ATTACH_BIN="$HOME/.local/bin/tuios-attach"

# Ensure wrapper exists
if [ ! -x "$ATTACH_BIN" ]; then
  ATTACH_BIN=$(command -v tuios 2>/dev/null || echo "/opt/homebrew/bin/tuios")
fi

# 1. Check if Ghostty application is running
GHOSTTY_RUNNING=$(osascript -e 'application "Ghostty" is running' 2>/dev/null || echo "false")

if [ "$GHOSTTY_RUNNING" != "true" ]; then
  # Ghostty is closed: launch Ghostty
  osascript -e 'tell application "Ghostty" to activate' >/dev/null 2>&1

  # Wait for Ghostty to launch and create its initial terminal surface
  for i in {1..30}; do
    count=$(osascript -e 'tell application "Ghostty" to count of terminals' 2>/dev/null || echo 0)
    if [ "$count" -gt 0 ]; then
      break
    fi
    sleep 0.1
  done
  sleep 0.2
fi

# 2. Inspect Ghostty's live terminals: focus existing or attach
RESULT=$(osascript 2>/dev/null <<EOF
tell application "Ghostty"
  -- Check if any terminal is already running tuios
  repeat with w in every window
    repeat with t in every terminal of w
      if name of t contains "tuios" then
        focus t
        activate
        return "focused-existing"
      end if
    end repeat
  end repeat

  -- Ghostty is running but no terminal is running tuios
  if (count of windows) > 0 then
    try
      set targetTerm to (focused terminal of selected tab of front window)
      input text "exec $ATTACH_BIN" & return to targetTerm
      activate
      return "attached-in-front-window"
    on error
      set targetTerm to (item 1 of terminals of item 1 of windows)
      input text "exec $ATTACH_BIN" & return to targetTerm
      activate
      return "attached-in-first-window"
    end try
  else
    new window
    delay 0.3
    input text "exec $ATTACH_BIN" & return to (terminal 1 of window 1)
    activate
    return "attached-in-new-window"
  end if
end tell
EOF
)

case "$RESULT" in
  "focused-existing")
    echo "Focused active TUIOS session in Ghostty"
    ;;
  "attached-in-front-window"|"attached-in-first-window")
    echo "Attached Ghostty to TUIOS (last session)"
    ;;
  "attached-in-new-window")
    echo "Opened new Ghostty window & attached to TUIOS"
    ;;
  *)
    osascript -e 'tell application "Ghostty" to activate' >/dev/null 2>&1
    echo "TUIOS ready in Ghostty"
    ;;
esac

exit 0
