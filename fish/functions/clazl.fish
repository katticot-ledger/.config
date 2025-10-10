#
# NAME
#   clazl - Run Claude AI assistant with Linear MCP integration and Z AI endpoint
#
# SYNOPSIS
#   clazl [OPTIONS] [ARGS...]
#
# DESCRIPTION
#   Wrapper function that runs claude with Linear MCP (Model Context Protocol)
#   configuration, dangerous mode enabled, and Z AI endpoint. This provides Claude with
#   access to Linear project management functionality for issue tracking, task management,
#   and team collaboration workflows, routing through the Z AI proxy endpoint.
#
# OPTIONS
#   All options are passed through to the underlying claude command.
#
# CONFIGURATION
#   Uses MCP configuration file: /Users/keita/.mcp-linear.json
#   Uses Z AI endpoint: https://api.z.ai/api/anthropic
#
# EXAMPLES
#   clazl "Create a new issue in Linear for the bug we found"
#   clazl "Show me all open issues assigned to me"
#   clazl "Update the status of issue ABC-123 to In Progress"
#
# CAUTION
#   This function skips permission checks which may be a security risk.
#
# SEE ALSO
#   cla(1) clad(1) claf(1) clal(1) claz(1)
#
function clazl --description "Run Claude AI assistant with Linear MCP integration and Z AI endpoint"
    # Export env vars only for this invocation
    set -lx ANTHROPIC_AUTH_TOKEN 'cc697eb7f30047ebb9bc388abb0c35f0.urarJjNwJ4EnoUzm'
    set -lx ANTHROPIC_BASE_URL 'https://api.z.ai/api/anthropic'

    claude --dangerously-skip-permissions --mcp-config /Users/keita/.mcp-linear.json $argv
end