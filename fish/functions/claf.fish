#
# NAME
#   claf - Run Claude AI assistant with Chrome Dev Tools MCP integration
#
# SYNOPSIS
#   claf [OPTIONS] [ARGS...]
#
# DESCRIPTION
#   Wrapper function that runs claude with Chrome Dev Tools MCP (Model Context Protocol)
#   configuration and dangerous mode enabled. This provides Claude with access to
#   Chrome Dev Tools functionality for browser automation and web development tasks.
#
# OPTIONS
#   All options are passed through to the underlying claude command.
#
# CONFIGURATION
#   Uses MCP configuration file: /Users/keita/.mcp-chrome-dev-tool.json
#
# EXAMPLES
#   claf "Help me debug this web page"
#   claf "Automate form submission on this website"
#
# CAUTION
#   This function skips permission checks which may be a security risk.
#
# SEE ALSO
#   cla(1) clad(1) clal(1) cladr(1)
#
function claf --description "Run Claude AI assistant with Chrome Dev Tools MCP integration"
    claude --mcp-config /Users/keita/.mcp-chrome-dev-tool.json --dangerously-skip-permissions $argv
end
