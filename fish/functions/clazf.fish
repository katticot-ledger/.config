#
# NAME
#   clazf - Run Claude AI assistant with Chrome Dev Tools MCP integration and Z AI endpoint
#
# SYNOPSIS
#   clazf [OPTIONS] [ARGS...]
#
# DESCRIPTION
#   Wrapper function that runs claude with Chrome Dev Tools MCP (Model Context Protocol)
#   configuration, dangerous mode enabled, and Z AI endpoint. This provides Claude with
#   access to Chrome Dev Tools functionality for browser automation and web development
#   tasks, routing through the Z AI proxy endpoint.
#
# OPTIONS
#   All options are passed through to the underlying claude command.
#
# CONFIGURATION
#   Uses MCP configuration file: /Users/keita/.mcp-chrome-dev-tool.json
#   Uses Z AI endpoint: https://api.z.ai/api/anthropic
#
# EXAMPLES
#   clazf "Help me debug this web page"
#   clazf "Automate form submission on this website"
#
# CAUTION
#   This function skips permission checks which may be a security risk.
#
# SEE ALSO
#   cla(1) clad(1) clal(1) claf(1) claz(1)
#
function clazf --description "Run Claude AI assistant with Chrome Dev Tools MCP integration and Z AI endpoint"
    # Export env vars only for this invocation
    set -lx ANTHROPIC_AUTH_TOKEN 'cc697eb7f30047ebb9bc388abb0c35f0.urarJjNwJ4EnoUzm'
    set -lx ANTHROPIC_BASE_URL 'https://api.z.ai/api/anthropic'

    claude --mcp-config /Users/keita/.mcp-chrome-dev-tool.json --dangerously-skip-permissions $argv
end