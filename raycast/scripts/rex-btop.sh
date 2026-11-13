#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Rex: btop (utils)
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🦎
# @raycast.packageName Rex

# Documentation:
# Open or focus the btop tab in the fixed "utils" Rex session.
# Creates the session/tab on first use; reuses it on later runs.

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/.local/bin:$PATH"

if [ "$(rex window list -s utils 2>/dev/null | grep -c '^[0-9]')" -gt 0 ]; then
  osascript -e 'tell application "Rex Beta" to show session "utils"'
else
  osascript <<'EOF'
tell application "Rex Beta"
  if not (exists session "utils") then
    new session named "utils"
  end if
  show (run command "btop" in "utils")
end tell
EOF
fi
