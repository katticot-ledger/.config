#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Kill All Games
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🛑
# @raycast.packageName Games

# Documentation:
# @raycast.description Force stop all running Steam games, Unity crash handlers, and Wine processes cleanly
# @raycast.author Antigravity

BOTTLE_DIR="/Users/keita/Library/Containers/com.franke.Whisky/Bottles/11EA6B13-902C-47F3-B5BC-D5548E9357D1"
WINE_BIN="/Users/keita/Library/Application Support/com.franke.Whisky/Libraries/Wine/bin"

if [ -f "$WINE_BIN/wineserver" ]; then
    WINEPREFIX="$BOTTLE_DIR" "$WINE_BIN/wineserver" -k 2>/dev/null || true
fi

killall -9 "Super Fantasy Kingdom.exe" "Combolands.exe" "Beyond These Stars Demo.exe" "Beyond These Stars.exe" "UnityCrashHandler64.exe" "wine64-preloader" "wineserver" 2>/dev/null || true
