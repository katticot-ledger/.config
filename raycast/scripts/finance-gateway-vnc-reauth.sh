#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Gateway VNC Re-auth
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔑
# @raycast.packageName Finance

# Documentation:
# Opens the VNC to matoury with the VNC password embedded (no prompt).
# The gateway password is typed manually into the IBKR login dialog.

open "vnc://:ibgateway@matoury.tail7a83e9.ts.net:5900"
